export interface ParsedArgs {
  positionals: string[];
  flags: Map<string, string[]>;
  passthrough: string[];
}

export function parseArgs(argv: string[]): ParsedArgs {
  const positionals: string[] = [];
  const flags = new Map<string, string[]>();
  const passthrough: string[] = [];

  for (let index = 0; index < argv.length; index++) {
    const arg = argv[index];

    if (arg === "--") {
      passthrough.push(...argv.slice(index + 1));
      break;
    }

    if (!arg.startsWith("--")) {
      positionals.push(arg);
      continue;
    }

    const raw = arg.slice(2);
    const equalsIndex = raw.indexOf("=");
    let name: string;
    let value: string;

    if (equalsIndex >= 0) {
      name = raw.slice(0, equalsIndex);
      value = raw.slice(equalsIndex + 1);
    } else if (raw.startsWith("no-")) {
      name = raw.slice(3);
      value = "false";
    } else if (argv[index + 1] && !argv[index + 1].startsWith("--")) {
      name = raw;
      value = argv[++index];
    } else {
      name = raw;
      value = "true";
    }

    const values = flags.get(name) ?? [];
    values.push(value);
    flags.set(name, values);
  }

  return { positionals, flags, passthrough };
}

export function getFlag(args: ParsedArgs, name: string): string | undefined {
  const values = args.flags.get(name);
  return values?.[values.length - 1];
}

export function getFlagValues(args: ParsedArgs, name: string): string[] {
  return args.flags.get(name) ?? [];
}

export function getBooleanFlag(args: ParsedArgs, name: string, defaultValue = false): boolean {
  const value = getFlag(args, name);
  if (value === undefined) {
    return defaultValue;
  }

  return !["0", "false", "no", "off"].includes(value.toLowerCase());
}

export function getCsvFlag(args: ParsedArgs, name: string, defaultValue: string[] = []): string[] {
  const value = getFlag(args, name);
  if (!value) {
    return defaultValue;
  }

  return value.split(",").map((item) => item.trim()).filter(Boolean);
}