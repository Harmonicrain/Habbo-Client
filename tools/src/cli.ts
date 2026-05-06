import { runAssets } from "./commands/assets";
import { runBuild } from "./commands/build";
import { runGamedata } from "./commands/gamedata";
import { runImports } from "./commands/imports";
import { runPackets } from "./commands/packets";
import { runSwf } from "./commands/swf";
import { runSymbols } from "./commands/symbols";

type CommandRunner = (argv: string[]) => Promise<void>;

const commands = new Map<string, CommandRunner>([
  ["build", runBuild],
  ["compile", runBuild],
  ["gamedata", runGamedata],
  ["imports", runImports],
  ["assets", runAssets],
  ["symbols", runSymbols],
  ["packets", runPackets],
  ["swf", runSwf],
]);

async function main(argv: string[]): Promise<void> {
  const command = argv[0];
  if (!command || command === "help" || command === "--help") {
    printHelp();
    return;
  }

  const runner = commands.get(command);
  if (!runner) {
    printHelp();
    throw new Error(`Unknown tool command: ${command}`);
  }

  await runner(argv.slice(1));
}

function printHelp(): void {
  console.log(`Usage: npm run tool -- <command> [options]

Commands:
  build                 Compile the AS3 client and archive the SWF
  gamedata migrate      Convert flat Habbo gamedata .txt files to verified JSON
  imports generate      Generate import stubs for AS3 compiler/bootstrap work
  assets report         Inspect Embed wrappers and missing asset files
  assets normalize      Rename obfuscated asset files from Class assignments
  assets rename-wrappers Rename obfuscated asset wrappers
  symbols compare       Compare symbols against a reference tree
  packets report        Export HabboMessages packet id maps
  swf extract-assets    Extract image assets from SWF/uncompressed SWF data

Run a command with --help for command-specific options.`);
}

main(process.argv.slice(2)).catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});