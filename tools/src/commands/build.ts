import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import * as fs from "node:fs/promises";
import * as path from "node:path";
import { parseArgs, getBooleanFlag, getFlag } from "../lib/args";
import { ensureDir, exists, fromRoot } from "../lib/fs";

interface AsConfig {
  compilerOptions?: Record<string, unknown>;
  files?: string[];
}

export async function runBuild(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  if (getBooleanFlag(args, "help")) {
    printBuildHelp();
    return;
  }

  const root = fromRoot();
  const asconfig = await readAsConfig(fromRoot("asconfig.json"));
  const options = asconfig.compilerOptions ?? {};
  const flexHome = path.resolve(getFlag(args, "flex-home") ?? process.env.FLEX_HOME ?? "C:\\flex");
  const javaPath = resolveJava(getFlag(args, "java"));
  const mxmlcJar = path.resolve(getFlag(args, "mxmlc") ?? process.env.MXMLC_JAR ?? path.join(flexHome, "lib", "mxmlc.jar"));
  const sourceFile = path.resolve(root, getFlag(args, "source") ?? asconfig.files?.[0] ?? "src/Habbo.as");
  const binDir = path.resolve(root, getFlag(args, "bin") ?? "bin");
  const stableOutputFile = path.resolve(root, getFlag(args, "output") ?? path.join("bin", "Habbo.swf"));
  const tempOutputFile = path.join(binDir, `.Habbo-build-${process.pid}-${Date.now()}.swf`);
  const archiveBuilds = getBooleanFlag(args, "archive", true);

  if (!await exists(sourceFile)) {
    throw new Error(`Source file not found: ${sourceFile}`);
  }
  if (!existsSync(mxmlcJar)) {
    throw new Error(`mxmlc.jar not found: ${mxmlcJar}. Use --mxmlc or set MXMLC_JAR/FLEX_HOME.`);
  }

  await ensureDir(binDir);
  await ensureDir(path.dirname(stableOutputFile));

  const startTime = Date.now();
  const compilerArgs = buildCompilerArgs({
    sourceFile,
    tempOutputFile,
    root,
    flexHome,
    options,
    passthrough: args.passthrough,
  });

  const exitCode = await runCompiler(javaPath, mxmlcJar, compilerArgs, root, flexHome);
  const elapsed = Date.now() - startTime;

  if (exitCode !== 0) {
    throw new Error(`Compilation failed with code ${exitCode}`);
  }
  if (!await exists(tempOutputFile)) {
    throw new Error(`Compiler finished but did not create ${tempOutputFile}`);
  }

  await fs.copyFile(tempOutputFile, stableOutputFile);
  let archivedOutputFile: string | undefined;
  if (archiveBuilds) {
    archivedOutputFile = path.join(binDir, `PRODUCTION-${formatTimestamp(new Date())}-${String(elapsed % 1000).padStart(3, "0")}.swf`);
    await fs.copyFile(tempOutputFile, archivedOutputFile);
  }
  await fs.rm(tempOutputFile, { force: true });

  const seconds = Math.floor(elapsed / 1000);
  const milliseconds = String(elapsed % 1000).padStart(3, "0");
  console.log(`Completed in ${seconds}.${milliseconds}s`);
  console.log(`Updated: ${stableOutputFile}`);
  if (archivedOutputFile) {
    console.log(`Archived: ${archivedOutputFile}`);
  }
}

function buildCompilerArgs(input: {
  sourceFile: string;
  tempOutputFile: string;
  root: string;
  flexHome: string;
  options: Record<string, unknown>;
  passthrough: string[];
}): string[] {
  const options = input.options;
  const sourcePaths = Array.isArray(options["source-path"]) ? options["source-path"] as string[] : ["src"];
  const size = readSize(options["default-size"]);
  const args: string[] = [
    `+flexlib=${path.join(input.flexHome, "frameworks")}`,
    input.sourceFile,
    `-output=${input.tempOutputFile}`,
  ];

  for (const sourcePath of sourcePaths) {
    args.push(`-source-path+=${path.resolve(input.root, sourcePath)}`);
  }

  pushValue(args, "static-link-runtime-shared-libraries", options["static-link-runtime-shared-libraries"], true);
  pushValue(args, "target-player", options["target-player"], "25.0");
  pushValue(args, "swf-version", options["swf-version"], "25");
  pushValue(args, "default-background-color", options["default-background-color"], "#000000");
  pushValue(args, "use-network", options["use-network"], true);
  pushValue(args, "use-resource-bundle-metadata", options["use-resource-bundle-metadata"], true);
  pushSeparatedValue(args, "default-frame-rate", options["default-frame-rate"], 30);
  args.push("-default-size", String(size.width), String(size.height));
  pushValue(args, "accessible", options.accessible, false);
  pushValue(args, "benchmark", options.benchmark, false);
  pushValue(args, "debug", options.debug, true);
  pushValue(args, "optimize", options.optimize, false);
  pushValue(args, "show-unused-type-selector-warnings", options["show-unused-type-selector-warnings"], true);
  pushValue(args, "strict", options.strict, true);
  pushValue(args, "warnings", options.warnings, true);
  pushValue(args, "verbose-stacktraces", options["verbose-stacktraces"], true);

  return [...args, ...input.passthrough];
}

function pushValue(args: string[], name: string, value: unknown, fallback: unknown): void {
  args.push(`-${name}=${String(value ?? fallback)}`);
}

function pushSeparatedValue(args: string[], name: string, value: unknown, fallback: unknown): void {
  args.push(`-${name}`, String(value ?? fallback));
}

function readSize(value: unknown): { width: number; height: number } {
  if (typeof value === "object" && value !== null) {
    const record = value as Record<string, unknown>;
    return {
      width: Number(record.width ?? 800),
      height: Number(record.height ?? 600),
    };
  }

  return { width: 800, height: 600 };
}

async function readAsConfig(filePath: string): Promise<AsConfig> {
  if (!await exists(filePath)) {
    return {};
  }
  return JSON.parse(await fs.readFile(filePath, "utf8")) as AsConfig;
}

function resolveJava(explicitPath?: string): string {
  const executable = process.platform === "win32" ? "java.exe" : "java";
  const candidates = [
    explicitPath,
    process.env.JAVA_HOME ? path.join(process.env.JAVA_HOME, "bin", executable) : undefined,
    process.platform === "win32" ? "C:\\Program Files\\Java\\jdk-21\\bin\\java.exe" : undefined,
    "java",
  ].filter((candidate): candidate is string => Boolean(candidate));

  return candidates.find((candidate) => candidate === "java" || existsSync(candidate)) ?? candidates[0];
}

function runCompiler(javaPath: string, mxmlcJar: string, compilerArgs: string[], cwd: string, flexHome: string): Promise<number> {
  return new Promise((resolve, reject) => {
    const compiler = spawn(javaPath, ["-jar", mxmlcJar, ...compilerArgs], {
      cwd,
      env: {
        ...process.env,
        FLEX_HOME: flexHome,
        PLAYERGLOBAL_HOME: process.env.PLAYERGLOBAL_HOME ?? path.join(flexHome, "frameworks", "libs", "player"),
      },
      stdio: "inherit",
    });

    compiler.on("error", reject);
    compiler.on("close", (code) => resolve(code ?? 1));
  });
}

function formatTimestamp(date: Date): string {
  const pad = (value: number) => String(value).padStart(2, "0");
  return `${date.getFullYear()}${pad(date.getMonth() + 1)}${pad(date.getDate())}${pad(date.getHours())}${pad(date.getMinutes())}`;
}

function printBuildHelp(): void {
  console.log(`Usage: npm run tool -- build [options] [-- extra mxmlc args]

Options:
  --flex-home <dir>   Flex SDK root (default: FLEX_HOME or C:\\flex)
  --mxmlc <jar>       mxmlc.jar path (default: <flex-home>/lib/mxmlc.jar)
  --java <exe>        Java executable (default: JAVA_HOME or java)
  --source <file>     Entry AS3 file (default: asconfig files[0])
  --output <file>     Stable SWF output (default: bin/Habbo.swf)
  --bin <dir>         Archive/temp directory (default: bin)
  --no-archive        Do not create timestamped PRODUCTION builds`);
}