// record-with-leadin.js
// Wrap any client-paced action with OBS recording + lead-in / lead-out padding.
// Paste into the `execute` tool's `code` parameter and replace the body of
// `runAction()` with whatever you want captured (e.g., the corner-tour from
// animate-source.js).

// ---------- CONFIG ----------
const leadInMs  = 1000;  // pre-roll before the action starts
const leadOutMs = 1000;  // post-roll after the action ends
// ----------------------------

async function runAction() {
  // Replace this with your animation / scene changes / etc.
  // Use setTimeout for client-side timing, not obs_general_sleep.
  await new Promise(r => setTimeout(r, 2000));
}

// Make sure OBS is reachable first.
const conn = await call_tool('obs_is_connected', {});
if (!conn?.connected) {
  await call_tool('obs_connect', { host: 'localhost', port: 4455 });
}

// If a recording is already running, don't stomp on it — surface the state.
const before = await call_tool('obs_record_status', {});
if (before?.outputActive) {
  return { skipped: true, reason: 'Recording already active', status: before };
}

const recordDir = await call_tool('obs_config_get_record_directory', {});
await call_tool('obs_record_start', {});

let result;
try {
  await new Promise(r => setTimeout(r, leadInMs));
  result = await runAction();
  await new Promise(r => setTimeout(r, leadOutMs));
} finally {
  // Always stop the recording, even if the action threw.
  const stop = await call_tool('obs_record_stop', {});
  result = { result, stop, recordDir };
}

return result;
