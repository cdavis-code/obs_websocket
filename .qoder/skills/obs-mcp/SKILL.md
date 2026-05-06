---
name: obs-mcp
description: Control a running OBS Studio instance through the obs-mcp-stdio MCP server. Use when the user asks to connect to OBS, list or switch scenes, inspect or transform sources, control audio inputs, start/stop streaming or recording, trigger hotkeys, manage filters or transitions, or run any OBS WebSocket operation. Exposes 60+ tools via an `execute` + JavaScript invocation pattern.
---

# OBS MCP (obs-mcp-stdio)

Agent guide for controlling OBS Studio via the `obs-mcp-stdio` MCP server. The server wraps the [obs_mcp](../../packages/obs_mcp) Dart package and speaks OBS WebSocket v5.x to a locally running OBS instance.

## Quick Start

```javascript
// 1. Check connection
const status = await call_tool('obs_is_connected', {});

// 2. Connect if needed
if (!status?.connected) {
  await call_tool('obs_connect', { host: 'localhost', port: 4455 });
}

// 3. Get current scene info
const scenes = await call_tool('obs_scenes_list', {});
return { current: scenes.currentProgramSceneName, total: scenes.scenes.length };
```

## Key Concepts

- **Scene Collection**: A complete project configuration containing all scenes, sources, filters, and settings
- **Scene**: A composition of multiple sources that can be switched between during streaming/recording
- **Source**: An individual element (video, audio, image, text, browser, etc.) placed within a scene
- **Scene Item**: A source's instance within a specific scene (has transform, visibility, and positioning data)
- **Filter**: An effect applied to a source (video processing, audio effects, chroma key, etc.)
- **Transition**: Visual effect used when switching between scenes (cut, fade, swipe, etc.)
- **Input**: OBS v5 terminology for sources that produce media (cameras, capture cards, audio devices, media files)

## When to Use

Use this skill whenever the user wants to:
- Check whether OBS is reachable, connect, or disconnect.
- Read OBS state: version, stats, hotkeys, scenes, scene items, inputs.
- Change OBS state: switch scenes, set transforms, mute/volume, create/remove items.
- Drive outputs: streaming, recording, virtual camera, replay buffer.
- Animate a source on-canvas or script a timed sequence.
- Trigger a hotkey, a vendor request, or a raw WebSocket request.

## Critical Invocation Pattern

The server exposes only **two** top-level tools: `search` and `execute`. All 60+ OBS operations are invoked **inside JavaScript** passed to `execute`.

**Do NOT** try to call `obs_scenes_list` (or any `obs_*` tool) directly — it is not registered as a top-level MCP tool and will fail with "tool not found".

**Do this instead**:
```javascript
// execute tool, code parameter:
const scenes = await call_tool('obs_scenes_list', {});
return scenes;
```

Rules:
- Every OBS call is `await call_tool('<tool_name>', { ...params })`.
- Use `Promise.all([...])` to parallelize independent reads.
- `return <value>` from the code to surface results back to the agent.
- Timing/animation must use client-side `setTimeout` (see Gotchas). `obs_general_sleep` sleeps on the server and will **not** pace client loops.

## Discovery Workflow

Before inventing a tool name, discover it:
```javascript
// Via the MCP search tool (not execute):
search({ query: "scene items transform", detail_level: "detailed" })
```
`detail_level` options: `"brief"` (name + description), `"detailed"` (+ parameter names/types/required), `"full"` (complete parameter schemas).

Use `search` when:
- You're unsure of the exact tool name.
- You need the parameter schema for a tool you haven't called before.
- A call fails with a schema error — re-check `detail_level: "full"`.

## Tool Catalog (60+ tools, by category)

All names below are invoked as `call_tool('<name>', {...})` inside `execute`.

### Connection
- `obs_connect` — connect to OBS WebSocket (host, port, password).
- `obs_disconnect` — close the connection.
- `obs_is_connected` — returns `{ connected: bool }`.
- `obs_send_raw` — send a raw OBS WebSocket request by op code/type.

### Source Types Reference

When creating or configuring sources with `obs_inputs_create` or `obs_scene_items_create`, common source types include:

| Type | Description | Common Use Case |
| --- | --- | --- |
| `video_capture_device` | Webcam/capture card | Camera input |
| `display_capture` | Full screen capture | Desktop/screen sharing |
| `window_capture` | Single window capture | Application-specific capture |
| `image_source` | Static image file | Logos, overlays, backgrounds |
| `ffmpeg_source` / `media_source` | Video/audio file | Pre-recorded media |
| `browser_source` | Web page source | Browser-based overlays, alerts |
| `text_ft2_source_v2` / `text_gdiplus_v2` | Text overlay | Titles, lower thirds |
| `color_source_v3` | Solid color | Backgrounds, mattes |
| `audio_input_capture` | Microphone | Voice input |
| `audio_output_capture` | Desktop audio | System audio capture |
| `group` | Source group | Organize multiple sources |
| `scene` | Nested scene | Scene-within-scene compositions |

> Note: Source type availability may vary by platform (macOS/Windows/Linux). Use `obs_inputs_get_kind_list` to discover available types at runtime.

### General
- `obs_general_version` — OBS/websocket/platform versions.
- `obs_general_stats` — CPU %, memory, FPS, render/output frame stats.
- `obs_general_hotkeys` — list registered hotkey names.
- `obs_general_trigger_hotkey` — trigger by hotkey name.
- `obs_general_trigger_hotkey_by_key` — trigger by key id + modifiers.
- `obs_general_sleep` — **server-side** sleep (ms). Do not use for client-paced loops.
- `obs_general_broadcast_custom_event` — broadcast an arbitrary JSON event.
- `obs_general_call_vendor_request` — call a vendor (plugin) request.

### Scenes
- `obs_scenes_list` — list scenes and current program/preview.
- `obs_scenes_group_list` — list groups.
- `obs_scenes_get_current_program`, `obs_scenes_set_current_program`.
- `obs_scenes_get_current_preview`, `obs_scenes_set_current_preview`.
- `obs_scenes_create`, `obs_scenes_remove`, `obs_scenes_set_name`.
- `obs_scenes_get_transition_override`, `obs_scenes_set_transition_override`.

### Scene Items
- `obs_scene_items_list` — list items in a scene (names, IDs, transforms).
- `obs_scene_items_get_id` — resolve `sceneItemId` by source name.
- `obs_scene_items_get_transform`, `obs_scene_items_set_transform` — position, scale, rotation, crop, bounds.
- `obs_scene_items_set_enabled`, `obs_scene_items_get_enabled`.
- `obs_scene_items_set_locked`, `obs_scene_items_get_locked`.
- `obs_scene_items_set_index`, `obs_scene_items_get_index` — z-order.
- `obs_scene_items_set_blend_mode`, `obs_scene_items_get_blend_mode`.
- `obs_scene_items_create`, `obs_scene_items_duplicate`, `obs_scene_items_remove`.
- `obs_scene_items_get_private_settings`, `obs_scene_items_set_private_settings`.

### Inputs
- `obs_inputs_list`, `obs_inputs_get_kind_list`, `obs_inputs_get_special`.
- `obs_inputs_create`, `obs_inputs_remove`, `obs_inputs_set_name`.
- `obs_inputs_get_default_settings`, `obs_inputs_get_settings`, `obs_inputs_set_settings`.
- `obs_inputs_get_mute`, `obs_inputs_set_mute`, `obs_inputs_toggle_mute`.
- `obs_inputs_get_volume`, `obs_inputs_set_volume`.
- `obs_inputs_get_audio_balance`, `obs_inputs_set_audio_balance`.
- `obs_inputs_get_audio_sync_offset`, `obs_inputs_set_audio_sync_offset`.
- `obs_inputs_get_audio_monitor_type`, `obs_inputs_set_audio_monitor_type`.
- `obs_inputs_get_audio_tracks`, `obs_inputs_set_audio_tracks`.
- `obs_inputs_get_properties_list_property_items`, `obs_inputs_press_properties_button`.

### Media Inputs
- `obs_media_get_status`, `obs_media_set_cursor`, `obs_media_offset_cursor`.
- `obs_media_trigger_action` — play / pause / restart / stop / next / previous.

### Sources
- `obs_sources_get_active`, `obs_sources_get_screenshot`, `obs_sources_save_screenshot`.

### Transitions
- `obs_transitions_list`, `obs_transitions_get_kind_list`.
- `obs_transitions_get_current`, `obs_transitions_set_current`.
- `obs_transitions_get_current_cursor`, `obs_transitions_trigger_studio_mode`.
- `obs_transitions_get_duration`, `obs_transitions_set_duration`.
- `obs_transitions_get_settings`, `obs_transitions_set_settings`.

### Filters
- `obs_filters_list`, `obs_filters_get_default_settings`, `obs_filters_get_kind_list`.
- `obs_filters_create`, `obs_filters_remove`, `obs_filters_set_name`, `obs_filters_set_index`.
- `obs_filters_get`, `obs_filters_set_settings`, `obs_filters_set_enabled`.

### Filter Types Reference

Common filter types available for sources:

**Video Filters:**
- `color_correction_v3` — Adjust gamma, contrast, brightness, saturation, hue
- `chroma_key_filter` — Green/blue screen removal with spill reduction
- `color_key_filter` — Key on specific color (alternative to chroma key)
- `lut_filter` — Apply color LUT (Look-Up Table) file
- `crop_to_filter` — Crop edges of source
- `scroll_filter` — Scrolling/panning effect
- `sharpness_filter_v2` — Image sharpening
- `scale_filter` — Resize source

**Audio Filters:**
- `noise_suppress_filter_v2` — Noise suppression (RNNoise/Speex algorithms)
- `gain_filter` — Volume gain/amplification
- `compressor_filter_v2` — Dynamic range compression
- `noise_gate_filter_v2` — Silence detection gate
- `limiter_filter` — Prevent audio clipping
- `expander_filter` — Expand dynamic range
- `vst_filter` — VST plugin host (platform-dependent)

> Use `obs_filters_get_kind_list` to discover all available filter types for a specific source.

### Outputs
- `obs_outputs_list`, `obs_outputs_get_status`, `obs_outputs_toggle`.
- `obs_outputs_start`, `obs_outputs_stop`, `obs_outputs_get_settings`, `obs_outputs_set_settings`.

### Streaming
- `obs_stream_status`, `obs_stream_toggle`, `obs_stream_start`, `obs_stream_stop`.
- `obs_stream_send_caption`.

### Recording
- `obs_record_status`, `obs_record_toggle`, `obs_record_start`, `obs_record_stop`.
- `obs_record_toggle_pause`, `obs_record_pause`, `obs_record_resume`.
- `obs_record_split_file`, `obs_record_create_chapter`, `obs_record_directory`.

### Virtual Camera
- `obs_virtual_cam_status`, `obs_virtual_cam_toggle`, `obs_virtual_cam_start`, `obs_virtual_cam_stop`.

### Replay Buffer
- `obs_replay_buffer_status`, `obs_replay_buffer_toggle`.
- `obs_replay_buffer_start`, `obs_replay_buffer_stop`, `obs_replay_buffer_save`.
- `obs_replay_buffer_get_last_replay`.

### Canvas / Projectors
- `obs_canvas_get_video_settings`, `obs_canvas_set_video_settings`.
- `obs_canvas_open_projector`.

### Configuration
- `obs_config_get_profile_parameter`, `obs_config_set_profile_parameter`.
- `obs_config_get_persistent_data`, `obs_config_set_persistent_data`.
- `obs_config_list_scene_collections`, `obs_config_get_current_scene_collection`, `obs_config_set_current_scene_collection`.
- `obs_config_create_scene_collection`, `obs_config_list_profiles`, `obs_config_get_current_profile`, `obs_config_set_current_profile`, `obs_config_create_profile`, `obs_config_remove_profile`.
- `obs_config_get_record_directory`, `obs_config_set_record_directory`.
- `obs_config_get_stream_service_settings`, `obs_config_set_stream_service_settings`.

### UI
- `obs_ui_get_studio_mode_enabled`, `obs_ui_set_studio_mode_enabled`.
- `obs_ui_open_input_properties_dialog`, `obs_ui_open_input_filters_dialog`, `obs_ui_open_input_interact_dialog`.
- `obs_ui_open_video_mix_projector`, `obs_ui_open_source_projector`, `obs_ui_open_scene_projector`.
- `obs_ui_open_video_mix_window_projector`, `obs_ui_open_source_window_projector`, `obs_ui_open_scene_window_projector`.
- `obs_ui_get_monitor_list`.

> Always confirm exact parameter names with `search(detail_level: "detailed" | "full")` before calling an unfamiliar tool — this catalog lists tool names only.

## Common Workflows

### 1. Verify connection before any work
```javascript
const status = await call_tool('obs_is_connected', {});
if (!status?.connected) {
  await call_tool('obs_connect', { host: 'localhost', port: 4455 });
}
return await call_tool('obs_general_version', {});
```

### 2. Inventory the active scene
```javascript
const scenes = await call_tool('obs_scenes_list', {});
const current = scenes.currentProgramSceneName;
const items = await call_tool('obs_scene_items_list', { sceneName: current });
return { scene: current, items };
```

### 3. Resolve a source by name, then read its transform
```javascript
const sceneName = (await call_tool('obs_scenes_list', {})).currentProgramSceneName;
const { sceneItemId } = await call_tool('obs_scene_items_get_id', {
  sceneName, sourceName: 'Follow Test'
});
const { sceneItemTransform } = await call_tool('obs_scene_items_get_transform', {
  sceneName, sceneItemId
});
return { sceneItemId, transform: sceneItemTransform };
```

### 4. Transform a source (position / rotation / scale)
```javascript
await call_tool('obs_scene_items_set_transform', {
  sceneName: 'Scene',
  sceneItemId: 4,
  sceneItemTransform: { positionX: 100, positionY: 100, rotation: 0 }
});
```
Always save the original transform first so you can restore it.

### 5. Animate a source (client-paced, with easing)
See [scripts/animate-source.js](scripts/animate-source.js) for a reusable template with `easeOutBounce` and a corner-tour example.

Key requirements:
- Pace frames with `await new Promise(r => setTimeout(r, 16))` (~60 fps). Never use `obs_general_sleep` for client-side animation.
- Interpolate `positionX`/`positionY` only. Keep rotation/scale fixed unless animating them too.
- When the user says "move the mid-point of the source to X", compute `posX = X - width/2`, `posY = Y - height/2` using the width/height from `sceneItemTransform`.
- Restore the original transform at the end.

### 6. Record a clip with lead-in / lead-out
See [scripts/record-with-leadin.js](scripts/record-with-leadin.js).

Pattern:
```javascript
await call_tool('obs_record_start', {});
await new Promise(r => setTimeout(r, leadInMs));
await runAnimation();
await new Promise(r => setTimeout(r, leadOutMs));
const { outputPath } = await call_tool('obs_record_stop', {});
return outputPath;
```
Recording directory defaults to the value returned by `obs_config_get_record_directory` (e.g. `/Users/<me>/Movies` on macOS).

### 7. Toggle streaming / recording / virtual cam
```javascript
await call_tool('obs_stream_toggle', {});        // start or stop stream
await call_tool('obs_record_toggle', {});        // start or stop recording
await call_tool('obs_virtual_cam_toggle', {});   // start or stop virtual cam
```

### 8. Audio controls
```javascript
await call_tool('obs_inputs_set_mute',  { inputName: 'Mic/Aux', inputMuted: true });
await call_tool('obs_inputs_set_volume', { inputName: 'Mic/Aux', inputVolumeDb: -6.0 });
```

### 9. Switch scenes (studio mode aware)
```javascript
const studio = await call_tool('obs_ui_get_studio_mode_enabled', {});
if (studio.studioModeEnabled) {
  await call_tool('obs_scenes_set_current_preview', { sceneName: 'Break' });
  await call_tool('obs_transitions_trigger_studio_mode', {});
} else {
  await call_tool('obs_scenes_set_current_program', { sceneName: 'Break' });
}
```

### 10. Trigger a hotkey
```javascript
const { hotkeys } = await call_tool('obs_general_hotkeys', {});
await call_tool('obs_general_trigger_hotkey', { hotkeyName: 'OBSBasic.StartRecording' });
```

## Gotchas & Best Practices

1. **`obs_general_sleep` is server-side.** It pauses the Dart server, not your JS execution. For client-paced timing use `await new Promise(r => setTimeout(r, ms))`.
2. **Snapshot before you mutate.** Call `obs_scene_items_get_transform` and store the result before animating so you can restore exactly.
3. **Use UUIDs when ambiguous.** `sceneUuid` and `sourceUuid` are safer than names if the user might rename things mid-session.
4. **Canvas size matters for positioning.** Read `obs_canvas_get_video_settings` to get `baseWidth`/`baseHeight` — don't hard-code 1920×1080.
5. **Minimize round-trips.** Parallelize independent reads with `Promise.all([...])`.
6. **Transform payload shape.** `obs_scene_items_set_transform` takes `{ sceneName, sceneItemId, sceneItemTransform: { ...fields } }` — transform fields are nested, not top-level.
7. **Animations swallow errors silently.** Wrap loops in `try/finally` and always restore the original transform in `finally`.
8. **Recording and streaming are asynchronous.** After `obs_record_stop`, the file path may not be available until the output flushes; poll `obs_record_status` if needed.
9. **Don't call tools concurrently on the same scene item.** Serialize writes to avoid race conditions in OBS.
10. **Verify connection first.** Every workflow should begin with `obs_is_connected` — OBS may have closed the WebSocket between calls.

## Scripts

Reusable templates the agent can copy into `execute`:

- [scripts/connection-check.js](scripts/connection-check.js) — verify/auto-connect + print version.
- [scripts/animate-source.js](scripts/animate-source.js) — corner-tour animation with `easeOutBounce` and mid-point offset.
- [scripts/record-with-leadin.js](scripts/record-with-leadin.js) — wrap any async function with recording + lead-in/lead-out.

## References

- Server package: [packages/obs_mcp](../../packages/obs_mcp)
- OBS WebSocket v5 protocol: <https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md>
