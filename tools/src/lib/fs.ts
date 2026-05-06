import * as fs from "node:fs/promises";
import * as path from "node:path";

export const repoRoot = path.resolve(__dirname, "..", "..", "..");

export function fromRoot(...segments: string[]): string {
  return path.resolve(repoRoot, ...segments);
}

export function toPosix(filePath: string): string {
  return filePath.split(path.sep).join("/");
}

export function relativeToRoot(filePath: string): string {
  return toPosix(path.relative(repoRoot, filePath));
}

export async function exists(filePath: string): Promise<boolean> {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

export async function ensureDir(dirPath: string): Promise<void> {
  await fs.mkdir(dirPath, { recursive: true });
}

export async function readText(filePath: string): Promise<string> {
  return fs.readFile(filePath, "utf8");
}

export async function writeText(filePath: string, content: string): Promise<void> {
  await ensureDir(path.dirname(filePath));
  await fs.writeFile(filePath, content, "utf8");
}

export async function walkFiles(
  dirPath: string,
  predicate: (filePath: string) => boolean = () => true,
): Promise<string[]> {
  const files: string[] = [];
  const entries = await fs.readdir(dirPath, { withFileTypes: true });

  for (const entry of entries) {
    const entryPath = path.join(dirPath, entry.name);
    if (entry.isDirectory()) {
      files.push(...await walkFiles(entryPath, predicate));
    } else if (entry.isFile() && predicate(entryPath)) {
      files.push(entryPath);
    }
  }

  return files.sort((left, right) => left.localeCompare(right));
}