#!/usr/bin/env node

const _debug = process.env.OBS_MCP_DEBUG === '1';

if (_debug) process.stderr.write('[obs-mcp-js] Starting obs-mcp-server.js entry point\n');

// ---------------------------------------------------------------------------
// Keep Node.js alive regardless of stdin/event-loop state.
// dart2js awaits a Dart Future (server.done) but Node.js doesn't know about
// pending Dart futures — it exits when the event loop is empty. This interval
// prevents premature exit.
// ---------------------------------------------------------------------------
const _keepAlive = setInterval(() => {}, 1 << 30); // ~12 days

// Graceful shutdown on signals
function _shutdown(signal) {
  if (_debug) process.stderr.write(`[obs-mcp-js] Received ${signal}, shutting down...\n`);
  clearInterval(_keepAlive);
  process.exit(0);
}
process.on('SIGTERM', () => _shutdown('SIGTERM'));
process.on('SIGINT', () => _shutdown('SIGINT'));

// ---------------------------------------------------------------------------
// Error handling: log but do NOT exit.
// dart2js WebSocket errors often escape Dart's try/catch and surface here as
// uncaught exceptions. The Dart layer already handles them — killing the
// process would disconnect the MCP client for no reason.
// ---------------------------------------------------------------------------
process.on('uncaughtException', (err) => {
  process.stderr.write(`[obs-mcp-js] uncaughtException (non-fatal): ${err.message || err}\n`);
  if (_debug && err.stack) process.stderr.write(`[obs-mcp-js]   stack: ${err.stack}\n`);
});
process.on('unhandledRejection', (reason) => {
  if (_debug) process.stderr.write(`[obs-mcp-js] unhandledRejection (non-fatal): ${reason}\n`);
});

// Polyfill globals needed by dart2js runtime
if (typeof globalThis.self === 'undefined') {
  globalThis.self = globalThis;
}

// Polyfill WebSocket for Node < 22
if (typeof globalThis.WebSocket === 'undefined') {
  try {
    const { WebSocket } = await import('ws');
    globalThis.WebSocket = WebSocket;
    if (_debug) process.stderr.write('[obs-mcp-js] WebSocket polyfill loaded from ws package\n');
  } catch (e) {
    if (_debug) process.stderr.write(`[obs-mcp-js] WebSocket polyfill not available: ${e.message}\n`);
  }
}

// Set stdin to raw mode (Dart code handles Buffer→String conversion)
process.stdin.setEncoding(null);
process.stdin.resume();

if (_debug) process.stderr.write('[obs-mcp-js] About to load dart2js runtime...\n');

// Load the dart2js compiled runtime
await import('../dist/obs_mcp_server.runtime.js');

if (_debug) process.stderr.write('[obs-mcp-js] dart2js runtime loaded successfully\n');
