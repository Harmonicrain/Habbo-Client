import * as path from "node:path";
import { readText, relativeToRoot, walkFiles } from "./fs";

export interface As3File {
  filePath: string;
  relativePath: string;
  text: string;
  packageName: string;
  className: string;
}

export interface EmbedRecord {
  file: As3File;
  className: string;
  baseClassName: string;
  source: string;
  mimeType?: string;
}

export interface NamedSignature {
  name: string;
  signature: string;
}

export interface ClassAssignment {
  propertyName: string;
  assetClassName: string;
}

const identifierPattern = "A-Za-z0-9_$";

export async function scanAs3Files(srcDir: string): Promise<As3File[]> {
  const filePaths = await walkFiles(srcDir, (filePath) => filePath.toLowerCase().endsWith(".as"));
  const files: As3File[] = [];

  for (const filePath of filePaths) {
    const text = await readText(filePath);
    files.push({
      filePath,
      relativePath: relativeToRoot(filePath),
      text,
      packageName: parsePackageName(text),
      className: parseClassName(text) ?? path.basename(filePath, ".as"),
    });
  }

  return files;
}

export function parsePackageName(text: string): string {
  return text.match(/\bpackage(?:\s+([A-Za-z_][\w.]*))?\s*\{/)?.[1] ?? "";
}

export function parseClassName(text: string): string | undefined {
  return text.match(/\bclass\s+([A-Za-z_]\w*)\b/)?.[1];
}

export function parseImports(text: string): string[] {
  return Array.from(text.matchAll(/^\s*import\s+([A-Za-z_][\w.*]*)\s*;/gm), (match) => match[1]);
}

export function parseEmbeds(file: As3File): EmbedRecord[] {
  const embeds: EmbedRecord[] = [];
  const regex = /\[Embed\s*\(([\s\S]*?)\)\]\s*(?:public\s+)?class\s+([A-Za-z_]\w*)\s+extends\s+([A-Za-z_]\w*)/g;

  for (const match of file.text.matchAll(regex)) {
    const metadata = match[1];
    const source = metadata.match(/\bsource\s*=\s*"([^"]+)"/)?.[1];
    if (!source) {
      continue;
    }

    embeds.push({
      file,
      className: match[2],
      baseClassName: match[3],
      source,
      mimeType: metadata.match(/\bmimeType\s*=\s*"([^"]+)"/)?.[1],
    });
  }

  return embeds;
}

export function findClassAssignments(text: string): ClassAssignment[] {
  return Array.from(
    text.matchAll(/\b([A-Za-z_]\w*)\s*:\s*Class\s*=\s*([A-Za-z_]\w*)\s*;/g),
    (match) => ({ propertyName: match[1], assetClassName: match[2] }),
  );
}

export function parseFunctionSignatures(text: string): NamedSignature[] {
  const symbols: NamedSignature[] = [];
  const regex = /\bfunction\s+(?:get\s+|set\s+)?([A-Za-z_]\w*)\s*(\([^)]*\)\s*(?::\s*[^;\n{]+)?)/g;

  for (const match of text.matchAll(regex)) {
    symbols.push({ name: match[1], signature: normalizeFunctionSignature(match[2]) });
  }

  return symbols;
}

export function parseVariableSignatures(text: string): NamedSignature[] {
  const symbols: NamedSignature[] = [];
  const regex = /\b(?:var|const)\s+([A-Za-z_]\w*)\s*:\s*([^=;\n]+)(?:\s*=\s*[^;\n]+)?;/g;

  for (const match of text.matchAll(regex)) {
    symbols.push({ name: match[1], signature: match[2].replace(/\s+/g, "") });
  }

  return symbols;
}

export function fullyQualifiedName(file: As3File): string {
  return file.packageName ? `${file.packageName}.${file.className}` : file.className;
}

export function safeIdentifier(input: string): string {
  const clean = input.replace(/[^A-Za-z0-9_]/g, "_").replace(/_+/g, "_").replace(/^_+|_+$/g, "");
  if (!clean) {
    return "Asset";
  }

  return /^[A-Za-z_]/.test(clean) ? clean : `Asset_${clean}`;
}

export function wordReplaceAll(text: string, search: string, replacement: string): string {
  const regex = new RegExp(`(^|[^${identifierPattern}])(${escapeRegExp(search)})(?=$|[^${identifierPattern}])`, "g");
  return text.replace(regex, `$1${replacement}`);
}

export function escapeRegExp(input: string): string {
  return input.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function normalizeFunctionSignature(signature: string): string {
  const compact = signature.replace(/\s+/g, "");
  const closeParen = compact.indexOf(")");
  if (closeParen < 0) {
    return compact;
  }

  const params = compact.slice(0, closeParen + 1).replace(/\b[A-Za-z_]\w*(?=:)/g, "_");
  return params + compact.slice(closeParen + 1);
}