// connection-check.js
// Paste the body into the `execute` tool's `code` parameter.
// Verifies the OBS WebSocket connection is live and auto-connects if needed,
// then returns OBS / websocket / platform versions.

const status = await call_tool('obs_is_connected', {});

if (!status || !status.connected) {
  // Defaults match obs-websocket 5.x; override host/port/password as needed.
  await call_tool('obs_connect', {
    host: 'localhost',
    port: 4455,
    // password: 'your-password',
  });
}

const [version, stats] = await Promise.all([
  call_tool('obs_general_version', {}),
  call_tool('obs_general_stats', {}),
]);

return {
  connected: true,
  version,
  stats,
};
