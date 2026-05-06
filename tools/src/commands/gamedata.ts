import * as path from "node:path";
import { parseArgs, getBooleanFlag, getFlag } from "../lib/args";
import { ensureDir, exists, fromRoot, readText, writeText } from "../lib/fs";

type JsonNode = string | boolean | { [key: string]: JsonNode };

const lineSplit = /\n\r+|\n+|\r+/;
const trim = /^\s+|\s+$/g;
const sentinel = "$";
const readonlyMetaKey = "_readonly";

export async function runGamedata(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  const action = args.positionals[0] ?? "migrate";

  if (action !== "migrate" || getBooleanFlag(args, "help")) {
    printGamedataHelp();
    return;
  }

  const gamedataDir = await resolveGamedataDir(getFlag(args, "gamedata"));
  const strict = getBooleanFlag(args, "strict");

  await migrate(path.join(gamedataDir, "external_variables.txt"), path.join(gamedataDir, "external_variables.json"), false, strict);
  await migrate(path.join(gamedataDir, "external_flash_texts.txt"), path.join(gamedataDir, "external_flash_texts.json"), true, strict);
  await migrate(path.join(gamedataDir, "override", "external_override_variables.txt"), path.join(gamedataDir, "override", "external_override_variables.json"), false, strict);
  await migrate(path.join(gamedataDir, "override", "external_flash_override_texts.txt"), path.join(gamedataDir, "override", "external_flash_override_texts.json"), true, strict);
}

function parseFlat(text: string, isTexts: boolean): { collapsed: Record<string, string>; readonlyFlag: boolean; duplicates: Array<[string, number, number]> } {
  const pairs: Array<[string, string]> = [];
  const seen = new Map<string, number>();
  const duplicates: Array<[string, number, number]> = [];
  let readonlyFlag = false;

  for (const [lineIndex, raw] of text.split(lineSplit).entries()) {
    const lineNumber = lineIndex + 1;
    if (!raw || raw.startsWith("#") || !raw.includes("=")) {
      continue;
    }

    const equalsIndex = raw.indexOf("=");
    const key = raw.slice(0, equalsIndex).replace(trim, "");
    let value = raw.slice(equalsIndex + 1).replace(trim, "");

    if (isTexts) {
      if (!key) {
        continue;
      }
      value = value.replace(/\\n/g, "\n");
      if (!value) {
        continue;
      }
    } else {
      if (!key || !value) {
        continue;
      }
      if (key === "configuration.readonly" && value === "true") {
        readonlyFlag = true;
        continue;
      }
    }

    const firstSeen = seen.get(key);
    if (firstSeen !== undefined) {
      duplicates.push([key, firstSeen, lineNumber]);
    }
    seen.set(key, lineNumber);
    pairs.push([key, value]);
  }

  const collapsed: Record<string, string> = {};
  for (const [key, value] of pairs) {
    collapsed[key] = value;
  }

  return { collapsed, readonlyFlag, duplicates };
}

async function migrate(srcPath: string, dstPath: string, isTexts: boolean, strict: boolean): Promise<void> {
  if (!await exists(srcPath)) {
    console.warn(`SKIP [${srcPath}]: not found`);
    return;
  }

  const { collapsed, readonlyFlag, duplicates } = parseFlat(await readText(srcPath), isTexts);
  for (const [key, first, last] of duplicates) {
    console.warn(`WARN [${path.basename(srcPath)}]: duplicate key ${JSON.stringify(key)} at lines ${first} and ${last} (keeping last)`);
  }

  const tree = buildTree(collapsed);
  if (readonlyFlag) {
    tree[readonlyMetaKey] = true;
  }

  const reparsed: Record<string, string> = {};
  flatten(tree, "", reparsed);
  delete reparsed[readonlyMetaKey];
  const diffs = Array.from(new Set([...Object.keys(collapsed), ...Object.keys(reparsed)])).filter((key) => collapsed[key] !== reparsed[key]);
  if (diffs.length > 0) {
    const sample = diffs.slice(0, 20).map((key) => `  ${JSON.stringify(key)}: original=${JSON.stringify(collapsed[key])} reparsed=${JSON.stringify(reparsed[key])}`).join("\n");
    throw new Error(`ERROR [${path.basename(srcPath)}]: round-trip mismatch on ${diffs.length} keys\n${sample}`);
  }

  await ensureDir(path.dirname(dstPath));
  await writeText(dstPath, `${stableJson(tree)}\n`);
  console.log(`OK [${path.basename(srcPath)}] -> ${path.basename(dstPath)} (${Object.keys(collapsed).length} keys, ${duplicates.length} dupes)`);

  if (strict && duplicates.length > 0) {
    throw new Error(`Duplicate keys found in strict mode: ${srcPath}`);
  }
}

function buildTree(collapsed: Record<string, string>): Record<string, JsonNode> {
  const root: Record<string, JsonNode> = {};
  for (const [key, value] of Object.entries(collapsed)) {
    insert(root, key, value);
  }
  return root;
}

function insert(root: Record<string, JsonNode>, key: string, value: string): void {
  const parts = key.split(".");
  let node = root;

  for (let index = 0; index < parts.length; index++) {
    const part = parts[index];
    const last = index === parts.length - 1;

    if (last) {
      const existing = node[part];
      if (existing && typeof existing === "object") {
        existing[sentinel] = value;
      } else {
        node[part] = value;
      }
    } else {
      const existing = node[part];
      if (!existing) {
        node[part] = {};
      } else if (typeof existing === "string") {
        node[part] = { [sentinel]: existing };
      }
      node = node[part] as Record<string, JsonNode>;
    }
  }
}

function flatten(node: JsonNode, prefix: string, out: Record<string, string>): void {
  if (typeof node === "object") {
    if (typeof node[sentinel] === "string") {
      out[prefix] = node[sentinel];
    }
    for (const [key, value] of Object.entries(node)) {
      if (key === sentinel) {
        continue;
      }
      flatten(value, prefix ? `${prefix}.${key}` : key, out);
    }
  } else if (typeof node === "string") {
    out[prefix] = node;
  }
}

function stableJson(value: JsonNode): string {
  return JSON.stringify(sortJson(value), null, 2);
}

function sortJson(value: JsonNode): JsonNode {
  if (!value || typeof value !== "object") {
    return value;
  }

  return Object.fromEntries(Object.keys(value).sort().map((key) => [key, sortJson(value[key])]));
}

async function resolveGamedataDir(explicit?: string): Promise<string> {
  if (explicit) {
    return path.resolve(explicit);
  }

  if (process.env.HABBO_GAMEDATA_DIR) {
    return path.resolve(process.env.HABBO_GAMEDATA_DIR);
  }

  const local = fromRoot("gamedata");
  if (await exists(local)) {
    return local;
  }

  return "C:\\habbo\\client\\habbo-swfs\\gamedata";
}

function printGamedataHelp(): void {
  console.log(`Usage: npm run tool -- gamedata migrate [options]

Options:
  --gamedata <dir>  Directory containing external_variables.txt files
  --strict          Fail if duplicate keys are found`);
}