import * as path from "node:path";
import { parseArgs, getBooleanFlag, getFlag } from "../lib/args";
import { NamedSignature, parseFunctionSignatures, parseVariableSignatures, scanAs3Files, wordReplaceAll } from "../lib/as3";
import { exists, fromRoot, readText, relativeToRoot, writeText } from "../lib/fs";

interface SymbolReplacement {
  filePath: string;
  oldName: string;
  newName: string;
  signature: string;
}

export async function runSymbols(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  const action = args.positionals[0] ?? "compare";
  if (action !== "compare" || getBooleanFlag(args, "help")) {
    printSymbolsHelp();
    return;
  }

  const kind = getFlag(args, "kind") ?? args.positionals[1] ?? "functions";
  if (kind !== "functions" && kind !== "variables") {
    throw new Error(`Unknown symbol kind: ${kind}`);
  }

  const srcDir = path.resolve(fromRoot(), getFlag(args, "src") ?? "src");
  const referenceDir = path.resolve(fromRoot(), getFlag(args, "reference") ?? "air");
  if (!await exists(referenceDir)) {
    throw new Error(`Reference directory not found: ${referenceDir}`);
  }

  const classFilter = getFlag(args, "class");
  const includeAll = getBooleanFlag(args, "all");
  const replacements = await compareSymbols(srcDir, referenceDir, kind, classFilter, includeAll);
  const report = replacements
    .map((replacement) => `${relativeToRoot(replacement.filePath)}: ${replacement.oldName} => ${replacement.newName} (${replacement.signature})`)
    .join("\n");

  if (getFlag(args, "out")) {
    await writeText(path.resolve(fromRoot(), getFlag(args, "out")!), `${report}\n`);
    console.log(`Wrote ${replacements.length} replacement(s) to ${getFlag(args, "out")}`);
  } else {
    console.log(report || "No symbol replacements found.");
  }

  if (getBooleanFlag(args, "apply")) {
    await applyReplacements(srcDir, replacements);
    console.log(`Applied ${replacements.length} replacement(s).`);
  } else if (replacements.length > 0) {
    console.log("Dry run only. Re-run with --apply to modify source files.");
  }
}

async function compareSymbols(
  srcDir: string,
  referenceDir: string,
  kind: "functions" | "variables",
  classFilter: string | undefined,
  includeAll: boolean,
): Promise<SymbolReplacement[]> {
  const replacements: SymbolReplacement[] = [];
  const parser = kind === "functions" ? parseFunctionSignatures : parseVariableSignatures;

  for (const file of await scanAs3Files(srcDir)) {
    if (classFilter && file.className !== classFilter) {
      continue;
    }

    const referencePath = path.join(referenceDir, path.relative(srcDir, file.filePath));
    if (!await exists(referencePath)) {
      continue;
    }

    const oldSymbols = parser(file.text);
    const newSymbols = parser(await readText(referencePath));
    const oldNames = new Set(oldSymbols.map((symbol) => symbol.name));
    const usedNewNames = new Set<string>();

    for (const oldSymbol of oldSymbols) {
      if (!includeAll && !oldSymbol.name.includes("_Str_")) {
        continue;
      }

      const candidates = findCandidates(oldSymbol, newSymbols, oldNames).filter((candidate) => !usedNewNames.has(candidate.name));
      if (candidates.length !== 1) {
        continue;
      }

      const newSymbol = candidates[0];
      usedNewNames.add(newSymbol.name);
      replacements.push({ filePath: file.filePath, oldName: oldSymbol.name, newName: newSymbol.name, signature: oldSymbol.signature });
    }
  }

  return replacements;
}

function findCandidates(oldSymbol: NamedSignature, newSymbols: NamedSignature[], oldNames: Set<string>): NamedSignature[] {
  return newSymbols.filter((newSymbol) => (
    newSymbol.signature === oldSymbol.signature &&
    newSymbol.name !== oldSymbol.name &&
    !oldNames.has(newSymbol.name)
  ));
}

async function applyReplacements(srcDir: string, replacements: SymbolReplacement[]): Promise<void> {
  const replacementMap = new Map<string, string>();
  for (const replacement of replacements) {
    const existing = replacementMap.get(replacement.oldName);
    if (existing && existing !== replacement.newName) {
      console.warn(`SKIP conflicting replacement for ${replacement.oldName}: ${existing} / ${replacement.newName}`);
      continue;
    }
    replacementMap.set(replacement.oldName, replacement.newName);
  }

  for (const file of await scanAs3Files(srcDir)) {
    let text = file.text;
    for (const [oldName, newName] of replacementMap) {
      text = wordReplaceAll(text, oldName, newName);
    }
    if (text !== file.text) {
      await writeText(file.filePath, text);
    }
  }
}

function printSymbolsHelp(): void {
  console.log(`Usage: npm run tool -- symbols compare [functions|variables] [options]

Options:
  --src <dir>          Current AS3 source root (default: src)
  --reference <dir>    Reference source root to compare against (default: air)
  --class <name>       Limit comparison to one class
  --all                Include non-_Str_ names too
  --out <file>         Write report to a file
  --apply              Apply safe word replacements across src`);
}