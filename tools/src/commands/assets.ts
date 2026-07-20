import * as fs from "node:fs/promises";
import * as path from "node:path";
import { parseArgs, getBooleanFlag, getCsvFlag, getFlag } from "../lib/args";
import { EmbedRecord, findClassAssignments, parseEmbeds, safeIdentifier, scanAs3Files, wordReplaceAll } from "../lib/as3";
import { exists, fromRoot, readText, relativeToRoot, walkFiles, writeText } from "../lib/fs";

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

  if (action === "consolidate") {
    await consolidateImages(args);
    return;
  }

  if (action === "embed-into-components") {
    await embedIntoComponents(args);
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

interface EmbedClass {
  className: string;
  definition: string;
  sourceExtension: string;
  filePath: string;
}

async function consolidateImages(args: ReturnType<typeof parseArgs>): Promise<void> {
  const srcDir = path.resolve(fromRoot(), getFlag(args, "src") ?? "src");
  const apply = getBooleanFlag(args, "apply");
  const imagesDir = path.join(srcDir, "images");

  if (!await exists(imagesDir)) {
    console.log(`Directory not found: ${imagesDir}`);
    return;
  }

  const filePaths = (await walkFiles(imagesDir, (f) => f.toLowerCase().endsWith(".as")))
    .filter((f) => !f.includes("/bak/"));

  const allClasses: EmbedClass[] = [];
  const classRegex = /\[Embed\(([^)]*)\)\]\s*(?:\/\/[^\n]*)?\s*public\s+class\s+(\w+)\s+extends\s+(\w+)\s*\{[^}]*\}/g;

  for (const filePath of filePaths) {
    const text = await readText(filePath);
    const baseName = path.basename(filePath, ".as");
    let skipFile = false;

    let match: RegExpExecArray | null;
    classRegex.lastIndex = 0;
    let found = false;

    while ((match = classRegex.exec(text)) !== null) {
      found = true;
      const className = match[2];

      // CRITICAL: Only process files where class name matches filename.
      // This guards against re-reading consolidated files as input.
      if (className !== baseName) {
        skipFile = true;
        continue;
      }

      const source = match[1].match(/source\s*=\s*"([^"]+)"/)?.[1];
      const ext = source ? path.extname(source).toLowerCase() : "";
      allClasses.push({
        className,
        definition: match[0],
        sourceExtension: ext,
        filePath,
      });
    }

    if (skipFile) {
      console.log(`  SKIP ${relativeToRoot(filePath)} (already a consolidated file)`);
    } else if (!found) {
      console.warn(`  WARN: no embed class found in ${relativeToRoot(filePath)}`);
    }
  }

  // Group by prefix (first segment before '_')
  const groups = new Map<string, EmbedClass[]>();
  for (const cls of allClasses) {
    const prefix = cls.className.includes("_") ? cls.className.substring(0, cls.className.indexOf("_")) : cls.className;
    const list = groups.get(prefix) ?? [];
    list.push(cls);
    groups.set(prefix, list);
  }

  const sortedGroups = Array.from(groups.entries()).sort((a, b) => a[0].localeCompare(b[0]));

  console.log(`\nFound ${allClasses.length} individual embed classes in ${filePaths.length} files.`);
  console.log(`Groups to consolidate: ${sortedGroups.length}\n`);

  for (const [prefix, classes] of sortedGroups) {
    const alreadyExists = await exists(path.join(imagesDir, `${prefix}.as`));
    console.log(`  ${prefix}: ${classes.length} assets -> ${prefix}.as${alreadyExists ? " (will overwrite)" : ""}`);
    if (!apply) {
      for (const cls of classes.slice(0, 3)) {
        console.log(`    - ${cls.className} (${relativeToRoot(cls.filePath)})`);
      }
      if (classes.length > 3) {
        console.log(`    ... and ${classes.length - 3} more`);
      }
    }
  }

  if (!apply) {
    console.log(`\nDry run. ${allClasses.length} files would be consolidated into ${sortedGroups.length} files.`);
    console.log("Re-run with --apply to execute.");
    return;
  }

  // Write consolidated files and delete originals
  for (const [prefix, classes] of sortedGroups) {
    const outputPath = path.join(imagesDir, `${prefix}.as`);

    // Build consolidated file content
    // Strip original indentation from definitions and apply clean 4-space indent
    const definitions = classes.map((c) => c.definition.replace(/^[ \t]+/gm, "").replace(/^/gm, "    ")).join("\n\n");
    const content = `package images\n{\n    import mx.core.BitmapAsset;\n\n${definitions}\n}\n`;

    await writeText(outputPath, content);
    console.log(`  WROTE ${relativeToRoot(outputPath)} (${classes.length} classes)`);

    // Delete individual files (only if they differ from the output)
    for (const cls of classes) {
      if (cls.filePath === outputPath) {
        // Single-file group where source == output; already written, nothing to delete
        continue;
      }
      await fs.rm(cls.filePath, { force: true });
      console.log(`  DELETED ${relativeToRoot(cls.filePath)}`);
    }
  }

  console.log(`\nDone! ${allClasses.length} files consolidated into ${sortedGroups.length} files.`);
  console.log("Now updating HabboAir.as imports...");

  // Update HabboAir.as to use wildcard import
  const habboAirPath = path.join(srcDir, "HabboAir.as");
  if (await exists(habboAirPath)) {
    let habboAirText = await readText(habboAirPath);
    const explicitImageImports = habboAirText.matchAll(/import\s+images\.\w+\s*;/g);
    const imageImports = Array.from(explicitImageImports);

    if (imageImports.length > 0) {
      // Check if there's already a wildcard import
      if (habboAirText.includes("import images.*;")) {
        // Just remove explicit imports (wildcard already exists)
        for (const imp of imageImports) {
          habboAirText = habboAirText.replace(imp[0], "");
        }
        // Clean up empty lines
        habboAirText = habboAirText.replace(/\n{3,}/g, "\n\n");
      } else {
        // Replace the first explicit import with wildcard, remove the rest
        const firstImport = imageImports[0];
        habboAirText = habboAirText.replace(firstImport[0], "import images.*;");
        for (let i = 1; i < imageImports.length; i++) {
          habboAirText = habboAirText.replace(imageImports[i][0], "");
        }
        habboAirText = habboAirText.replace(/\n{3,}/g, "\n\n");
      }
      await writeText(habboAirPath, habboAirText);
      console.log(`  UPDATED ${relativeToRoot(habboAirPath)} - replaced ${imageImports.length} explicit import(s) with wildcard`);
    } else {
      console.log(`  No explicit image imports to update in ${relativeToRoot(habboAirPath)}`);
    }
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

async function embedIntoComponents(args: ReturnType<typeof parseArgs>): Promise<void> {
  const srcDir = path.resolve(fromRoot(), getFlag(args, "src") ?? "src");
  const apply = getBooleanFlag(args, "apply");

  // Define the two asset directories to process
  const assetDirs: { dir: string; pkg: string; importPrefix: string; baseClass: string }[] = [
    { dir: "images", pkg: "images", importPrefix: "images", baseClass: "BitmapAsset" },
    { dir: "binaryData", pkg: "binaryData", importPrefix: "binaryData", baseClass: "ByteArrayAsset" },
    { dir: "sounds", pkg: "sounds", importPrefix: "sounds", baseClass: "SoundAsset" },
  ];

  // Step 1: Build className -> {source, mimeType?} map from all individual wrapper files
  type AssetInfo = { source: string; mimeType?: string; dir: string };
  const classMap = new Map<string, AssetInfo>();
  let totalWrapperFiles = 0;
  let allWrapperFiles: string[] = [];

  const embedRegex = /\[Embed\(([^)]*)\)\]\s*(?:\/\/[^\n]*)?\s*public\s+class\s+(\w+)\s+extends\s+(\w+)\s*\{[^}]*\}/g;

  for (const ad of assetDirs) {
    const assetDir = path.join(srcDir, ad.dir);
    if (!await exists(assetDir)) {
      console.log(`Directory not found: ${assetDir}, skipping...`);
      continue;
    }

    const wrapperFiles = await walkFiles(assetDir, (f) => f.toLowerCase().endsWith(".as"));
    totalWrapperFiles += wrapperFiles.length;
    allWrapperFiles.push(...wrapperFiles);

    for (const filePath of wrapperFiles) {
      const text = await readText(filePath);
      let match: RegExpExecArray | null;
      while ((match = embedRegex.exec(text)) !== null) {
        const className = match[2];
        const meta = match[1];
        const source = meta.match(/source\s*=\s*"([^"]+)"/)?.[1];
        const mimeType = meta.match(/mimeType\s*=\s*"([^"]+)"/)?.[1];
        if (source) {
          classMap.set(className, { source, mimeType, dir: ad.dir });
        }
      }
    }
  }

  console.log(`Found ${classMap.size} asset classes in ${totalWrapperFiles} files.\n`);

  // Step 2: Find component files to update (src/*.as, excluding asset dirs, bak/, com/, snowwar/)
  const skipDirs = new Set(assetDirs.map((ad) => path.join(srcDir, ad.dir)));
  const componentFiles = (await walkFiles(srcDir, (f) => f.toLowerCase().endsWith(".as")))
    .filter((f) => !f.includes("/bak/") && !f.includes("/com/") && !f.includes("/snowwar/") && !Array.from(skipDirs).some((d) => f.startsWith(d)));

  // Step 3: Process each component file
  // Match: (public|private|protected) static (var|const) X:Class = ClassName;
  const assignRegex = /(?:public|private|protected)\s+static\s+(var|const)\s+(\w+)\s*:\s*Class\s*=\s*(\w+)\s*;/g;
  let totalReplacements = 0;

  for (const filePath of componentFiles) {
    let text = await readText(filePath);
    let hasChanges = false;

    // --- A) Replace static Class assignments with [Embed] annotations ---
    text = text.replace(assignRegex, (fullMatch, varOrConst, propertyName, className) => {
      const info = classMap.get(className);
      if (!info) {
        return fullMatch; // Not an asset class (e.g., manifest, other)
      }
      const action = apply ? "" : "[DRY] ";
      const matchPrivate = fullMatch.startsWith("private") ? "private " : "";
      const matchProtected = fullMatch.startsWith("protected") ? "protected " : "";
      const matchPublic = (!matchPrivate && !matchProtected) ? "public " : "";
      const visibility = matchPrivate || matchProtected || matchPublic;
      console.log(`  ${action}${relativeToRoot(filePath)}: ${visibility}static ${varOrConst} ${propertyName}:Class = ${className}`);
      totalReplacements++;
      hasChanges = true;
      const mimeAttr = info.mimeType ? `, mimeType="${info.mimeType}"` : "";
      return `[Embed(source="${info.dir}/${info.source}"${mimeAttr})]\n    ${visibility}static ${varOrConst} ${propertyName}:Class;`;
    });

    // --- B) Remove import images.* / import binaryData.*; ---
    for (const ad of assetDirs) {
      const importPattern = new RegExp(`^\\s*import\\s+${ad.importPrefix}\\.\\*\\s*;\\n?`, "gm");
      if (importPattern.test(text)) {
        importPattern.lastIndex = 0;
        text = text.replace(importPattern, "");
        console.log(`  ${apply ? "" : "[DRY] "}${relativeToRoot(filePath)}: removed import ${ad.importPrefix}.*;`);
        hasChanges = true;
      }
    }

    // --- C) Remove explicit import images.SpecificClass / import binaryData.SpecificClass; ---
    for (const ad of assetDirs) {
      const explicitPattern = new RegExp(`^\\s*import\\s+${ad.importPrefix}\\.\\w+\\s*;\\n?`, "gm");
      const explicitCount = (text.match(explicitPattern) || []).length;
      if (explicitCount > 0) {
        explicitPattern.lastIndex = 0;
        text = text.replace(explicitPattern, "");
        console.log(`  ${apply ? "" : "[DRY] "}${relativeToRoot(filePath)}: removed ${explicitCount} explicit ${ad.importPrefix} import(s)`);
        hasChanges = true;
      }
    }

    // --- D) Clean up blank lines left by removed imports ---
    text = text.replace(/\n{3,}/g, "\n\n");

    if (hasChanges && apply) {
      await writeText(filePath, text);
    }
  }

  // --- E) Handle HabboAir.as: add [Embed] static consts for its own images ---
  const habboAirPath = path.join(srcDir, "HabboAir.as");
  if (await exists(habboAirPath)) {
    let habboAirText = await readText(habboAirPath);
    const originalHabboAir = habboAirText;

    // Find image classes that belong to HabboAir prefix
    const habboAirImages = Array.from(classMap.entries())
      .filter(([className]) => className.startsWith("HabboAir_") && !habboAirText.includes(`static const ${className.substring("HabboAir_".length)}:Class;`));

    if (habboAirImages.length > 0) {
      const embedConsts = habboAirImages.map(([className, info]) => {
        const shortName = className.substring("HabboAir_".length);
        const mimeAttr = info.mimeType ? `, mimeType="${info.mimeType}"` : "";
        return `        [Embed(source="images/${info.source}"${mimeAttr})]\n        public static const ${shortName}:Class;`;
      }).join("\n\n");

      const classOpenMatch = habboAirText.match(/(public\s+class\s+HabboAir\s+extends\s+\w+\s*\{)/);
      if (classOpenMatch) {
        const insertionPoint = classOpenMatch.index! + classOpenMatch[0].length;
        habboAirText = habboAirText.slice(0, insertionPoint) + "\n\n" + embedConsts + "\n" + habboAirText.slice(insertionPoint);
        console.log(`  ${apply ? "" : "[DRY] "}${relativeToRoot(habboAirPath)}: added ${habboAirImages.length} [Embed] static consts`);
      }

      // Replace direct usages
      for (const [className] of habboAirImages) {
        const shortName = className.substring("HabboAir_".length);
        const oldUsage = `new ${className}().bitmapData`;
        const newUsage = `new ${shortName}().bitmapData`;
        if (habboAirText.includes(oldUsage)) {
          habboAirText = habboAirText.split(oldUsage).join(newUsage);
          console.log(`  ${apply ? "" : "[DRY] "}  ${oldUsage} -> ${newUsage}`);
        }
      }
    }

    // Cross-reference warnings (images only - bitmapData pattern)
    const crossRefRegex = /new\s+(\w+)\(\)\.bitmapData/g;
    crossRefRegex.lastIndex = 0;
    habboAirText.replace(crossRefRegex, (fullMatch, className) => {
      if (classMap.has(className) && !className.startsWith("HabboAir_")) {
        const prefix = className.includes("_") ? className.substring(0, className.indexOf("_")) : className;
        console.log(`  ${apply ? "" : "[DRY] "}  WARN: ${fullMatch} needs manual update to reference ${prefix} static property`);
      }
      return fullMatch;
    });

    if (habboAirText !== originalHabboAir && apply) {
      await writeText(habboAirPath, habboAirText);
    }
  }

  console.log(`\n${apply ? "Applied" : "DRY RUN"}: ${totalReplacements} static var replacements across component files.`);

  // Step 4: Delete all individual wrapper files
  if (apply) {
    console.log("\nDeleting wrapper files...");
    for (const filePath of allWrapperFiles) {
      await fs.rm(filePath, { force: true });
    }
    console.log(`Deleted ${allWrapperFiles.length} wrapper files.`);
    console.log("\nDone! All embeds migrated into component files.");
    if (await exists(habboAirPath)) {
      console.log("NOTE: HabboAir.as may still have cross-component references needing manual review.");
    }
  } else {
    console.log(`\nDry run only. ${allWrapperFiles.length} wrapper files would be deleted.`);
    console.log("Re-run with --apply to execute.");
  }
}

function printAssetsHelp(): void {
  console.log(`Usage: npm run tool -- assets <command> [options]

Commands:
  report              Summarize Embed wrappers and missing asset files
  normalize           Rename obfuscated .png/.bin files using Class assignments (dry-run by default)
  rename-wrappers     Rename obfuscated wrapper classes/files to match clear asset names (dry-run by default)
  consolidate         Group single-embed .as files in src/images/ by prefix (dry-run by default)
  embed-into-components Move [Embed] annotations from src/images/ into the component static Class properties

Options:
  --src <dir>         AS3 source root (default: src)
  --types png,bin     Asset extensions for normalize (default: png,bin)
  --all               Include non-_Str_ names too
  --json              JSON output for report
  --apply             Actually change files`);
}