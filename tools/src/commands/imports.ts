import * as path from "node:path";
import { parseArgs, getBooleanFlag, getFlag, getFlagValues } from "../lib/args";
import { fullyQualifiedName, scanAs3Files } from "../lib/as3";
import { fromRoot, writeText } from "../lib/fs";

const defaultExcludes = new Set([
  "com.sulake.habbo.ui.widget.camera.PhotoPurchaseConfirmationDialog",
  "com.sulake.core.runtime.Profiler",
  "com.sulake.core.runtime.InterfaceStructList",
  "com.sulake.core.runtime.InterfaceStruct",
  "com.sulake.core.runtime.ComponentInterfaceQueue",
  "com.sulake.core.communication.wireformat.EvaMessageDataWrapper",
  "com.sulake.core.assets.loaders.AssetLoaderEventBroker",
  "com.hurlant.math.MontgomeryReduction",
  "com.hurlant.math.IReduction",
  "com.hurlant.math.ClassicReduction",
  "com.hurlant.math.BarrettReduction",
]);

export async function runImports(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  const action = args.positionals[0] ?? "generate";
  if (action !== "generate" || getBooleanFlag(args, "help")) {
    printImportsHelp();
    return;
  }

  const srcDir = path.resolve(fromRoot(), getFlag(args, "src") ?? "src");
  const outFile = path.resolve(fromRoot(), getFlag(args, "out") ?? "import.txt");
  const excludes = new Set([...defaultExcludes, ...getFlagValues(args, "exclude")]);
  const files = await scanAs3Files(srcDir);
  const lines = files
    .map(fullyQualifiedName)
    .filter((name) => !excludes.has(name))
    .sort((left, right) => left.localeCompare(right))
    .map((name) => `import ${name}; ${name};`);

  const content = `${lines.join("\n")}\n`;
  if (getBooleanFlag(args, "stdout")) {
    process.stdout.write(content);
  } else {
    await writeText(outFile, content);
    console.log(`Wrote ${lines.length} imports to ${outFile}`);
  }
}

function printImportsHelp(): void {
  console.log(`Usage: npm run tool -- imports generate [options]

Options:
  --src <dir>       AS3 source root (default: src)
  --out <file>      Output file (default: import.txt)
  --exclude <fqcn>  Exclude a class; can be repeated
  --stdout          Print instead of writing a file`);
}