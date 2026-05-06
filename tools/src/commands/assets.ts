import * as fs from "node:fs/promises";
import * as path from "node:path";
import { parseArgs, getBooleanFlag, getCsvFlag, getFlag } from "../lib/args";
import { EmbedRecord, findClassAssignments, parseEmbeds, safeIdentifier, scanAs3Files, wordReplaceAll } from "../lib/as3";
import { exists, fromRoot, readText, relativeToRoot, writeText } from "../lib/fs";

interface EmbedWithSource extends EmbedRecord {
  sourcePath: string;
  sourceExists: boolean;
}

interface AssetRenameOperation {
  wrapperPath: string;
  sourcePath: string;
  targetPath: string;
  oldSource: string;
  newSource: string;
  oldClassName: string;
  newClassName: string;
}

export async function runAssets(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  const action = args.positionals[0] ?? "report";

  if (getBooleanFlag(args, "help")) {
    printAssetsHelp();
    return;
  }

  if (action === "report") {
    await reportAssets(args);
    return;
  }

  if (action === "normalize") {
    await normalizeAssetFiles(args);
    return;
  }

  if (action === "rename-wrappers") {
    await renameWrappers(args);
    return;
  }

  printAssetsHelp();
}

async function reportAssets(args: ReturnType<typeof parseArgs>): Promise<void> {
  const records = await scanEmbeds(path.resolve(fromRoot(), getFlag(args, "src") ?? "src"));
  if (getBooleanFlag(args, "json")) {
    console.log(JSON.stringify(records.map(toJsonRecord), null, 2));
    return;
  }

  const missing = records.filter((record) => !record.sourceExists);
  const mismatched = records.filter((record) => path.basename(record.source, path.extname(record.source)) !== record.className);
  const byType = new Map<string, number>();
  for (const record of records) {
    const ext = path.extname(record.source).slice(1).toLowerCase() || "unknown";
    byType.set(ext, (byType.get(ext) ?? 0) + 1);
  }

  console.log(`Embed wrappers: ${records.length}`);
  console.log(`Missing sources: ${missing.length}`);
  console.log(`Class/source name mismatches: ${mismatched.length}`);
  console.log(`Types: ${Array.from(byType).sort().map(([type, count]) => `${type}=${count}`).join(", ")}`);

  for (const record of missing.slice(0, 40)) {
    console.log(`MISSING ${relativeToRoot(record.file.filePath)} -> ${record.source}`);
  }
}

async function normalizeAssetFiles(args: ReturnType<typeof parseArgs>): Promise<void> {
  const srcDir = path.resolve(fromRoot(), getFlag(args, "src") ?? "src");
  const apply = getBooleanFlag(args, "apply");
  const includeAll = getBooleanFlag(args, "all");
  const types = new Set(getCsvFlag(args, "types", ["png", "bin"]).map((type) => type.toLowerCase()));
  const files = await scanAs3Files(srcDir);
  const classTargets = new Map<string, string>();

  for (const file of files) {
    for (const assignment of findClassAssignments(file.text)) {
      if (!classTargets.has(assignment.assetClassName)) {
        classTargets.set(assignment.assetClassName, safeIdentifier(`${file.className}_${assignment.propertyName}`));
      }
    }
  }

  const operations: AssetRenameOperation[] = [];
  for (const file of files) {
    for (const embed of parseEmbeds(file)) {
      const extension = path.extname(embed.source).slice(1).toLowerCase();
      if (!types.has(extension)) {
        continue;
      }
      const sourceBase = path.basename(embed.source, path.extname(embed.source));
      if (!includeAll && !sourceBase.includes("_Str_")) {
        continue;
      }

      const targetBase = classTargets.get(embed.className);
      if (!targetBase || targetBase === sourceBase) {
        continue;
      }

      const sourceDir = embed.source.includes("/") ? embed.source.slice(0, embed.source.lastIndexOf("/") + 1) : "";
      const targetSource = `${sourceDir}${targetBase}.${extension}`;
      operations.push({
        wrapperPath: file.filePath,
        sourcePath: path.resolve(path.dirname(file.filePath), embed.source),
        targetPath: path.resolve(path.dirname(file.filePath), targetSource),
        oldSource: embed.source,
        newSource: targetSource,
        oldClassName: embed.className,
        newClassName: targetBase,
      });
    }
  }

  await applyOrPrintAssetOperations(operations, apply, false);
}

async function renameWrappers(args: ReturnType<typeof parseArgs>): Promise<void> {
  const srcDir = path.resolve(fromRoot(), getFlag(args, "src") ?? "src");
  const apply = getBooleanFlag(args, "apply");
  const includeAll = getBooleanFlag(args, "all");
  const operations: AssetRenameOperation[] = [];

  for (const record of await scanEmbeds(srcDir)) {
    const sourceBase = path.basename(record.source, path.extname(record.source));
    const fileBase = path.basename(record.file.filePath, ".as");
    if (!includeAll && !fileBase.includes("_Str_")) {
      continue;
    }
    if (!sourceBase || sourceBase === record.className || sourceBase.includes("_Str_")) {
      continue;
    }

    const newClassName = safeIdentifier(sourceBase);
    operations.push({
      wrapperPath: record.file.filePath,
      sourcePath: path.resolve(path.dirname(record.file.filePath), record.source),
      targetPath: path.join(path.dirname(record.file.filePath), `${newClassName}.as`),
      oldSource: record.source,
      newSource: record.source,
      oldClassName: record.className,
      newClassName,
    });
  }

  await applyOrPrintAssetOperations(operations, apply, true, srcDir);
}

async function applyOrPrintAssetOperations(operations: AssetRenameOperation[], apply: boolean, renameWrappers: boolean, srcDir?: string): Promise<void> {
  if (operations.length === 0) {
    console.log("No asset changes found.");
    return;
  }

  for (const operation of operations) {
    const label = renameWrappers ? "WRAPPER" : "ASSET";
    console.log(`${apply ? "APPLY" : "DRY"} ${label} ${relativeToRoot(operation.wrapperPath)}: ${operation.oldClassName} -> ${operation.newClassName}`);
    if (!renameWrappers) {
      console.log(`  ${operation.oldSource} -> ${operation.newSource}`);
    }
  }

  if (!apply) {
    console.log(`Dry run only. Re-run with --apply to modify ${operations.length} item(s).`);
    return;
  }

  if (renameWrappers && srcDir) {
    await applyWrapperRenames(operations, srcDir);
    return;
  }

  for (const operation of operations) {
    if (!await exists(operation.sourcePath)) {
      console.warn(`SKIP missing source: ${operation.sourcePath}`);
      continue;
    }
    if (operation.sourcePath !== operation.targetPath && await exists(operation.targetPath)) {
      console.warn(`SKIP target exists: ${operation.targetPath}`);
      continue;
    }

    if (operation.sourcePath !== operation.targetPath) {
      await fs.rename(operation.sourcePath, operation.targetPath);
    }
    const text = await readText(operation.wrapperPath);
    await writeText(operation.wrapperPath, text.replace(`source="${operation.oldSource}"`, `source="${operation.newSource}"`));
  }
}

async function applyWrapperRenames(operations: AssetRenameOperation[], srcDir: string): Promise<void> {
  const files = await scanAs3Files(srcDir);
  const replacements = new Map<string, string>();

  for (const operation of operations) {
    if (operation.oldClassName === operation.newClassName) {
      continue;
    }
    if (await exists(operation.targetPath)) {
      console.warn(`SKIP target exists: ${operation.targetPath}`);
      continue;
    }
    replacements.set(operation.oldClassName, operation.newClassName);
  }

  for (const file of files) {
    let text = file.text;
    for (const [oldName, newName] of replacements) {
      text = wordReplaceAll(text, oldName, newName);
    }
    if (text !== file.text) {
      await writeText(file.filePath, text);
    }
  }

  for (const operation of operations) {
    if (!replacements.has(operation.oldClassName)) {
      continue;
    }
    await fs.rename(operation.wrapperPath, operation.targetPath);
  }
}

async function scanEmbeds(srcDir: string): Promise<EmbedWithSource[]> {
  const records: EmbedWithSource[] = [];
  for (const file of await scanAs3Files(srcDir)) {
    for (const embed of parseEmbeds(file)) {
      const sourcePath = path.resolve(path.dirname(file.filePath), embed.source);
      records.push({ ...embed, sourcePath, sourceExists: await exists(sourcePath) });
    }
  }
  return records;
}

function toJsonRecord(record: EmbedWithSource): object {
  return {
    wrapper: relativeToRoot(record.file.filePath),
    packageName: record.file.packageName,
    className: record.className,
    baseClassName: record.baseClassName,
    source: record.source,
    sourceExists: record.sourceExists,
    sourcePath: relativeToRoot(record.sourcePath),
    mimeType: record.mimeType,
  };
}

function printAssetsHelp(): void {
  console.log(`Usage: npm run tool -- assets <command> [options]

Commands:
  report              Summarize Embed wrappers and missing asset files
  normalize           Rename obfuscated .png/.bin files using Class assignments (dry-run by default)
  rename-wrappers     Rename obfuscated wrapper classes/files to match clear asset names (dry-run by default)

Options:
  --src <dir>         AS3 source root (default: src)
  --types png,bin     Asset extensions for normalize (default: png,bin)
  --all               Include non-_Str_ names too
  --json              JSON output for report
  --apply             Actually change files`);
}