const fs = require("fs");
const http = require("http");
const path = require("path");
const { URL } = require("url");

const host = process.env.HOST || "127.0.0.1";
const port = Number(process.env.PORT || 8080);
const webRoot = path.resolve(__dirname, "..", "web");
const logPath = path.join(webRoot, "flash_client_error_log.json");
const maxReports = 50;

const mimeTypes = {
  ".css": "text/css; charset=utf-8",
  ".gif": "image/gif",
  ".html": "text/html; charset=utf-8",
  ".jpg": "image/jpeg",
  ".js": "application/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".png": "image/png",
  ".svg": "image/svg+xml",
  ".swf": "application/x-shockwave-flash",
  ".txt": "text/plain; charset=utf-8",
  ".xml": "application/xml; charset=utf-8"
};

function readReports() {
  try {
    return JSON.parse(fs.readFileSync(logPath, "utf8"));
  } catch (error) {
    return [];
  }
}

function writeReports(reports) {
  fs.writeFileSync(logPath, JSON.stringify(reports, null, 2));
}

function parseFormBody(rawBody) {
  const params = new URLSearchParams(rawBody);
  const fields = {};
  for (const [key, value] of params.entries()) {
    fields[key] = value;
  }
  return fields;
}

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    "Cache-Control": "no-store",
    "Content-Type": "application/json; charset=utf-8"
  });
  response.end(JSON.stringify(payload, null, 2));
}

function sendFile(response, filePath) {
  const extension = path.extname(filePath).toLowerCase();
  const contentType = mimeTypes[extension] || "application/octet-stream";
  response.writeHead(200, {
    "Cache-Control": "no-store",
    "Content-Type": contentType
  });
  fs.createReadStream(filePath).pipe(response);
}

function sendNotFound(response) {
  response.writeHead(404, {
    "Content-Type": "text/plain; charset=utf-8"
  });
  response.end("Not found");
}

function resolveStaticFile(urlPath) {
  const cleanPath = urlPath === "/" ? "/index.html" : urlPath;
  const requestedPath = path.normalize(decodeURIComponent(cleanPath)).replace(/^([\\/])+/, "");
  const filePath = path.join(webRoot, requestedPath);
  if (!filePath.startsWith(webRoot)) {
    return null;
  }
  if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    return null;
  }
  return filePath;
}

const server = http.createServer((request, response) => {
  const requestUrl = new URL(request.url, `http://${request.headers.host || `${host}:${port}`}`);

  if (request.method === "GET" && requestUrl.pathname === "/api/flash_client_error") {
    sendJson(response, 200, { reports: readReports() });
    return;
  }

  if (request.method === "POST" && requestUrl.pathname === "/flash_client_error") {
    const chunks = [];
    request.on("data", (chunk) => {
      chunks.push(chunk);
    });
    request.on("end", () => {
      const rawBody = Buffer.concat(chunks).toString("utf8");
      const fields = parseFormBody(rawBody);
      const reports = readReports();
      reports.unshift({
        receivedAt: new Date().toISOString(),
        method: request.method,
        path: requestUrl.pathname,
        userAgent: request.headers["user-agent"] || "",
        fields,
        rawBody
      });
      reports.splice(maxReports);
      writeReports(reports);
      sendFile(response, path.join(webRoot, "flash_client_error.html"));
    });
    return;
  }

  if (request.method === "GET" && requestUrl.pathname === "/flash_client_error") {
    sendFile(response, path.join(webRoot, "flash_client_error.html"));
    return;
  }

  if (request.method !== "GET" && request.method !== "HEAD") {
    response.writeHead(405, {
      "Content-Type": "text/plain; charset=utf-8"
    });
    response.end("Method not allowed");
    return;
  }

  const filePath = resolveStaticFile(requestUrl.pathname);
  if (!filePath) {
    sendNotFound(response);
    return;
  }
  if (request.method === "HEAD") {
    const extension = path.extname(filePath).toLowerCase();
    response.writeHead(200, {
      "Cache-Control": "no-store",
      "Content-Type": mimeTypes[extension] || "application/octet-stream"
    });
    response.end();
    return;
  }
  sendFile(response, filePath);
});

server.listen(port, host, () => {
  console.log(`Web server running on http://${host}:${port}`);
  console.log(`Crash viewer available at http://${host}:${port}/flash_client_error`);
});