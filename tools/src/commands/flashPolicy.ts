import * as net from "node:net";
import { parseArgs, getFlag, getBooleanFlag } from "../lib/args";

export async function runFlashPolicy(argv: string[]): Promise<void> {
  const args = parseArgs(argv);
  if (getBooleanFlag(args, "help")) {
    printFlashPolicyHelp();
    return;
  }

  const host = getFlag(args, "host") ?? process.env.FLASH_POLICY_HOST ?? "0.0.0.0";
  const port = Number(getFlag(args, "port") ?? process.env.FLASH_POLICY_PORT ?? 843);
  const allowedPorts = getFlag(args, "allow-ports") ?? process.env.FLASH_POLICY_ALLOW_PORTS ?? "*";
  const policy = buildPolicy(allowedPorts);

  await startPolicyServer({ host, port, allowedPorts, policy });
}

function buildPolicy(allowedPorts: string): string {
  return `<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
  <allow-access-from domain="*" to-ports="${allowedPorts}" secure="false" />
</cross-domain-policy>\0`;
}

function startPolicyServer(input: {
  host: string;
  port: number;
  allowedPorts: string;
  policy: string;
}): Promise<void> {
  return new Promise((resolve, reject) => {
    const server = net.createServer((socket) => {
      socket.once("data", (data) => {
        console.log(`Policy request: ${data.toString()}`);
        socket.write(input.policy);
        socket.end();
      });

      socket.on("error", () => {});
    });

    server.on("error", (error: NodeJS.ErrnoException) => {
      if (error.code === "EADDRINUSE") {
        console.log(`Flash policy server already running on port ${input.port}`);
        resolve();
        return;
      }

      if (error.code === "EACCES") {
        reject(new Error(`Flash policy server cannot bind port ${input.port}. Run VS Code or PowerShell as Administrator, or use --port <port>.`));
        return;
      }

      reject(new Error(`Flash policy server failed on port ${input.port}: ${error.message}`));
    });

    server.listen(input.port, input.host, () => {
      console.log(`Flash policy server running on port ${input.port}`);
      console.log(`Allowing Flash socket ports: ${input.allowedPorts}`);
      resolve();
    });
  });
}

function printFlashPolicyHelp(): void {
  console.log(`Usage: npm run tool -- flash-policy [options]

Options:
  --host <host>          Bind host (default: FLASH_POLICY_HOST or 0.0.0.0)
  --port <port>          Bind port (default: FLASH_POLICY_PORT or 843)
  --allow-ports <ports>  Flash socket ports to allow (default: FLASH_POLICY_ALLOW_PORTS or *)`);
}
