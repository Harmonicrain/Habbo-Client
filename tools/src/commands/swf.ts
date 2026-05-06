import * as fs from "node:fs/promises";
import * as path from "node:path";
import { inflateSync } from "node:zlib";
import { parseArgs, getBooleanFlag, getFlag, getFlagValues } from "../lib/args";
import { safeIdentifier } from "../lib/as3";
import { encodeRgbaPng } from "../lib/png";
import { ensureDir, fromRoot, relativeToRoot, writeText } from "../lib/fs";

interface SwfTag {
  code: number;
  data: Buffer;
}

interface ExtractedAsset {
  id: number;
  name: string;
  extension: string;
  data: Buffer;
}

export async function runSwf(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  const action = args.positionals[0] ?? "extract-assets";
  if (action !== "extract-assets" || getBooleanFlag(args, "help")) {
    printSwfHelp();
    return;
  }

  const input = getFlag(args, "input") ?? args.positionals[1];
  if (!input) {
    throw new Error("Missing --input <swf-or-uncompressed-bin>");
  }

  const inputPath = path.resolve(fromRoot(), input);
  const outDir = path.resolve(fromRoot(), getFlag(args, "out") ?? "extracted-assets");
  const wrapperDir = getFlag(args, "emit-wrappers") ? path.resolve(fromRoot(), getFlag(args, "emit-wrappers")!) : undefined;
  const nameFilters = getFlagValues(args, "name-contains").map((filter) => filter.toLowerCase());
  const idNames = parseIdNames(getFlagValues(args, "id"));
  const swfBody = getSwfBody(await fs.readFile(inputPath));
  const tags = parseTags(swfBody);
  const symbols = parseSymbols(tags);
  const assets = extractImageAssets(tags, symbols, idNames, nameFilters);

  await ensureDir(outDir);
  for (const asset of assets) {
    const fileName = `${safeIdentifier(asset.name)}.${asset.extension}`;
    const filePath = path.join(outDir, fileName);
    await fs.writeFile(filePath, asset.data);
    console.log(`Wrote ${relativeToRoot(filePath)} (CID ${asset.id})`);

    if (wrapperDir) {
      await writeImageWrapper(wrapperDir, safeIdentifier(asset.name), fileName);
    }
  }

  console.log(`Extracted ${assets.length} image asset(s).`);
}

function getSwfBody(buffer: Buffer): Buffer {
  const signature = buffer.subarray(0, 3).toString("ascii");
  if (signature === "FWS") {
    return buffer.subarray(8);
  }
  if (signature === "CWS") {
    return inflateSync(buffer.subarray(8));
  }
  return buffer;
}

function parseTags(body: Buffer): SwfTag[] {
  const tags: SwfTag[] = [];
  let position = skipMovieHeader(body);

  while (position + 2 <= body.length) {
    const header = body.readUInt16LE(position);
    position += 2;
    const code = header >> 6;
    let length = header & 0x3f;
    if (length === 0x3f) {
      if (position + 4 > body.length) {
        break;
      }
      length = body.readUInt32LE(position);
      position += 4;
    }

    const end = position + length;
    if (end > body.length) {
      break;
    }
    tags.push({ code, data: body.subarray(position, end) });
    position = end;
  }

  return tags;
}

function skipMovieHeader(body: Buffer): number {
  if (body.length === 0) {
    return 0;
  }
  const nbits = body[0] >> 3;
  const rectBytes = Math.ceil((5 + nbits * 4) / 8);
  return rectBytes + 4;
}

function parseSymbols(tags: SwfTag[]): Map<number, string> {
  const symbols = new Map<number, string>();
  for (const tag of tags) {
    if (tag.code !== 76 || tag.data.length < 2) {
      continue;
    }

    const count = tag.data.readUInt16LE(0);
    let offset = 2;
    for (let index = 0; index < count && offset + 2 <= tag.data.length; index++) {
      const id = tag.data.readUInt16LE(offset);
      offset += 2;
      const end = tag.data.indexOf(0, offset);
      if (end < 0) {
        break;
      }
      symbols.set(id, tag.data.subarray(offset, end).toString("utf8"));
      offset = end + 1;
    }
  }
  return symbols;
}

function extractImageAssets(tags: SwfTag[], symbols: Map<number, string>, idNames: Map<number, string>, nameFilters: string[]): ExtractedAsset[] {
  const assets: ExtractedAsset[] = [];

  for (const tag of tags) {
    const asset = decodeImageTag(tag, symbols, idNames);
    if (!asset) {
      continue;
    }

    const searchableName = asset.name.toLowerCase();
    const hasExplicitIds = idNames.size > 0;
    const matchesName = nameFilters.length === 0 || nameFilters.some((filter) => searchableName.includes(filter));
    if ((hasExplicitIds && !idNames.has(asset.id)) || !matchesName) {
      continue;
    }

    assets.push(asset);
  }

  return assets;
}

function decodeImageTag(tag: SwfTag, symbols: Map<number, string>, idNames: Map<number, string>): ExtractedAsset | undefined {
  if (tag.data.length < 2) {
    return undefined;
  }

  if (tag.code === 6 || tag.code === 21) {
    const id = tag.data.readUInt16LE(0);
    const data = tag.data.subarray(2);
    return { id, name: idNames.get(id) ?? symbols.get(id) ?? `asset_${id}`, extension: detectImageExtension(data), data };
  }

  if (tag.code === 35 && tag.data.length >= 6) {
    const id = tag.data.readUInt16LE(0);
    const alphaOffset = tag.data.readUInt32LE(2);
    const data = tag.data.subarray(6, 6 + alphaOffset);
    return { id, name: idNames.get(id) ?? symbols.get(id) ?? `asset_${id}`, extension: detectImageExtension(data), data };
  }

  if ((tag.code === 20 || tag.code === 36) && tag.data.length >= 7) {
    const id = tag.data.readUInt16LE(0);
    const format = tag.data[2];
    const width = tag.data.readUInt16LE(3);
    const height = tag.data.readUInt16LE(5);
    if (format !== 5) {
      return undefined;
    }

    const pixels = inflateSync(tag.data.subarray(7));
    const rgba = Buffer.alloc(width * height * 4);
    for (let pixel = 0; pixel < width * height; pixel++) {
      const source = pixel * 4;
      const target = pixel * 4;
      const alpha = tag.code === 36 ? pixels[source] : 255;
      const red = pixels[source + 1];
      const green = pixels[source + 2];
      const blue = pixels[source + 3];

      rgba[target] = alpha > 0 && alpha < 255 ? Math.min(255, Math.round(red * 255 / alpha)) : red;
      rgba[target + 1] = alpha > 0 && alpha < 255 ? Math.min(255, Math.round(green * 255 / alpha)) : green;
      rgba[target + 2] = alpha > 0 && alpha < 255 ? Math.min(255, Math.round(blue * 255 / alpha)) : blue;
      rgba[target + 3] = alpha;
    }

    return { id, name: idNames.get(id) ?? symbols.get(id) ?? `asset_${id}`, extension: "png", data: encodeRgbaPng(width, height, rgba) };
  }

  return undefined;
}

function detectImageExtension(data: Buffer): string {
  if (data.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) {
    return "png";
  }
  if (data[0] === 0xff && data[1] === 0xd8) {
    return "jpg";
  }
  if (data.subarray(0, 3).toString("ascii") === "GIF") {
    return "gif";
  }
  return "bin";
}

function parseIdNames(values: string[]): Map<number, string> {
  const idNames = new Map<number, string>();
  for (const value of values) {
    const [idRaw, name] = value.split("=");
    const id = Number(idRaw);
    if (!Number.isFinite(id) || !name) {
      throw new Error(`Invalid --id value: ${value}. Use --id 1455=ClassName`);
    }
    idNames.set(id, name);
  }
  return idNames;
}

async function writeImageWrapper(wrapperDir: string, className: string, sourceFileName: string): Promise<void> {
  const srcRoot = fromRoot("src");
  const relativeDir = path.relative(srcRoot, wrapperDir);
  const packageName = relativeDir.startsWith("..") ? "" : relativeDir.split(path.sep).filter(Boolean).join(".");
  const body = `${packageName ? `package ${packageName}` : "package"}\n{\n    import mx.core.BitmapAsset;\n\n    [Embed(source="${sourceFileName}")]\n    public class ${className} extends BitmapAsset \n    {\n    }\n}\n`;
  await writeText(path.join(wrapperDir, `${className}.as`), body);
}

function printSwfHelp(): void {
  console.log(`Usage: npm run tool -- swf extract-assets --input <file> [options]

Options:
  --input <file>           SWF or uncompressed SWF body
  --out <dir>              Output directory (default: extracted-assets)
  --id 1455=ClassName      Extract/map a specific character id; can be repeated
  --name-contains <text>   Filter SymbolClass names; can be repeated
  --emit-wrappers <dir>    Create BitmapAsset AS3 wrappers beside extracted files`);
}