import * as path from "node:path";
import { parseArgs, getBooleanFlag, getFlag } from "../lib/args";
import { parseImports } from "../lib/as3";
import { fromRoot, readText, writeText } from "../lib/fs";

interface PacketMapping {
  id: number;
  className: string;
  fullyQualifiedName?: string;
}

export async function runPackets(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  const action = args.positionals[0] ?? "report";
  if (action !== "report" || getBooleanFlag(args, "help")) {
    printPacketsHelp();
    return;
  }

  const sourceFile = path.resolve(fromRoot(), getFlag(args, "file") ?? "src/com/sulake/habbo/communication/HabboMessages.as");
  const report = buildPacketReport(await readText(sourceFile));
  const format = getFlag(args, "format") ?? "text";
  const content = format === "json" ? `${JSON.stringify(report, null, 2)}\n` : renderTextReport(report);

  if (getFlag(args, "out")) {
    const outFile = path.resolve(fromRoot(), getFlag(args, "out")!);
    await writeText(outFile, content);
    console.log(`Wrote packet report to ${outFile}`);
  } else {
    process.stdout.write(content);
  }
}

function buildPacketReport(text: string): { incoming: PacketMapping[]; outgoing: PacketMapping[] } {
  const importMap = new Map<string, string>();
  for (const importName of parseImports(text)) {
    importMap.set(importName.split(".").pop()!, importName);
  }

  const incoming: PacketMapping[] = [];
  const outgoing: PacketMapping[] = [];
  const regex = /\b(INCOMING_PACKETS|OUTGOING_PACKETS)\s*\[\s*(\d+)\s*\]\s*=\s*([A-Za-z_]\w*)\s*;/g;

  for (const match of text.matchAll(regex)) {
    const mapping = {
      id: Number(match[2]),
      className: match[3],
      fullyQualifiedName: importMap.get(match[3]),
    };
    if (match[1] === "INCOMING_PACKETS") {
      incoming.push(mapping);
    } else {
      outgoing.push(mapping);
    }
  }

  return {
    incoming: incoming.sort((left, right) => left.id - right.id),
    outgoing: outgoing.sort((left, right) => left.id - right.id),
  };
}

function renderTextReport(report: { incoming: PacketMapping[]; outgoing: PacketMapping[] }): string {
  const lines = [
    `Incoming packets: ${report.incoming.length}`,
    ...report.incoming.map((mapping) => `${String(mapping.id).padStart(5, " ")}  ${mapping.fullyQualifiedName ?? mapping.className}`),
    "",
    `Outgoing packets: ${report.outgoing.length}`,
    ...report.outgoing.map((mapping) => `${String(mapping.id).padStart(5, " ")}  ${mapping.fullyQualifiedName ?? mapping.className}`),
    "",
  ];
  return lines.join("\n");
}

function printPacketsHelp(): void {
  console.log(`Usage: npm run tool -- packets report [options]

Options:
  --file <path>       HabboMessages.as path
  --format text|json  Output format (default: text)
  --out <file>        Write report to a file`);
}