# obs_mcp

A standalone MCP (Model Context Protocol) server for controlling OBS Studio via the obs-websocket v5.x protocol. Built on top of the [`obs_websocket`](https://pub.dev/packages/obs_websocket) Dart library, it exposes OBS operations as MCP tools over stdio transport.

## What's New in v5.7.0

This release adds comprehensive support for OBS WebSocket v5.7.0 features:

- **Canvases**: New `canvases_list` tool to list all configured canvases
- **Input Audio Properties**: Full control over audio balance, sync offset, monitor type, and audio tracks
- **Input Properties Dialog**: Access to list property items and button presses
- **Scene Items Extended**: Access to source names and private settings
- **Transitions**: Complete transition management including kind listing, configuration, and T-Bar control
- **Filters**: Full filter lifecycle management (create, remove, rename, configure, reorder)
- **Outputs Extended**: List all outputs, get/set output status and settings

## Quick Start

```bash
# Install dependencies from the workspace root
dart pub get

# Generate the MCP dispatcher
cd packages/obs_mcp
dart run build_runner build --delete-conflicting-outputs

# Set connection details (or use a .env file)
export OBS_WEBSOCKET_URL=ws://localhost:4455
export OBS_WEBSOCKET_PASSWORD=your-password

# Run the server
dart run bin/obs_mcp_server.dart
```

## Features

All tools are prefixed with `obs_` and organized into the following groups:

| Group | Tools | Description |
|---|---|---|
| **Connection** | `connect`, `disconnect`, `is_connected`, `send_raw` | Manage the WebSocket connection to OBS |
| **General** | `general_version`, `general_stats`, `general_hotkeys`, `general_trigger_hotkey`, `general_sleep`, `general_broadcast_custom_event` | Retrieve OBS version/stats, trigger hotkeys, broadcast custom events |
| **Scenes** | `scenes_list`, `scenes_group_list`, `scenes_get_current_program`, `scenes_set_current_program`, `scenes_get_current_preview`, `scenes_set_current_preview`, `scenes_create` | List, switch, and create scenes |
| **Scene Items** | `scene_items_list`, `scene_items_group_list`, `scene_items_get_id`, `scene_items_get_enabled`, `scene_items_set_enabled`, `scene_items_get_locked`, `scene_items_set_locked`, `scene_items_set_transform`, `scene_items_get_source`, `scene_items_get_private_settings`, `scene_items_set_private_settings` | Query and control items within scenes, including position/scale/rotation/crop and private settings |
| **Inputs** | `inputs_list`, `inputs_kind_list`, `inputs_special`, `inputs_get_mute`, `inputs_set_mute`, `inputs_toggle_mute`, `inputs_get_volume`, `inputs_get_settings`, `inputs_set_settings`, `inputs_set_name`, `inputs_create`, `inputs_remove` | Manage audio/video inputs, mute, volume, and settings |
| **Inputs - Audio** | `inputs_get_audio_balance`, `inputs_set_audio_balance`, `inputs_get_audio_sync_offset`, `inputs_set_audio_sync_offset`, `inputs_get_audio_monitor_type`, `inputs_set_audio_monitor_type`, `inputs_get_audio_tracks`, `inputs_set_audio_tracks` | Control input audio properties: balance, sync offset, monitor type, and audio tracks |
| **Inputs - Properties** | `inputs_get_properties_list_items`, `inputs_press_properties_button` | Interact with input properties dialog (list items and button presses) |
| **Stream** | `stream_status`, `stream_start`, `stream_stop`, `stream_toggle`, `stream_send_caption` | Control live streaming and send captions |
| **Record** | `record_status`, `record_start`, `record_stop`, `record_toggle`, `record_pause`, `record_resume`, `record_toggle_pause` | Control recording sessions |
| **Outputs** | `outputs_virtual_cam_status/toggle/start/stop`, `outputs_replay_buffer_status/toggle/start/stop/save`, `outputs_toggle/start/stop`, `outputs_list`, `outputs_get_status`, `outputs_get_settings`, `outputs_set_settings` | Manage virtual camera, replay buffer, and arbitrary outputs |
| **Config** | `config_record_directory`, `config_stream_service_settings` | Read recording directory and stream service configuration |
| **UI** | `ui_studio_mode_enabled`, `ui_set_studio_mode`, `ui_open_input_properties/filters/interact`, `ui_monitor_list` | Toggle Studio Mode, open input dialogs, list monitors |
| **Transitions** | `transitions_trigger_studio`, `transitions_kind_list`, `transitions_scene_list`, `transitions_get_current`, `transitions_set_current`, `transitions_set_duration`, `transitions_set_settings`, `transitions_get_cursor`, `transitions_set_tbar` | Manage scene transitions: list kinds, configure current transition, T-Bar control |
| **Filters** | `filters_kind_list`, `filters_list`, `filters_default_settings`, `filters_create`, `filters_remove`, `filters_rename`, `filters_get`, `filters_set_index`, `filters_set_settings`, `filters_set_enabled` | Manage source filters: create, remove, configure, and reorder |
| **Canvases** | `canvases_list` | List canvases configured in OBS (v5.7.0+) |

Code mode is enabled, providing sandbox execution via a search/execute tool pair.

## Configuration

Environment variables can be set via the shell or a `.env` file. The server searches for `.env` in the following locations (in order): `.env`, `bin/.env`, or adjacent to the running script.

| Variable | Description | Default |
|---|---|---|
| `OBS_WEBSOCKET_URL` | WebSocket server URL (e.g., `ws://localhost:4455`) | &mdash; |
| `OBS_WEBSOCKET_PASSWORD` | Authentication password (omit for anonymous connections) | &mdash; |
| `OBS_WEBSOCKET_TIMEOUT` | Connection timeout in seconds | `120` |

## Building

### Prerequisites

- Dart SDK >= 3.8.0
- OBS Studio with obs-websocket v5.x (bundled with OBS 28+)

### Code Generation

The MCP dispatcher is generated with `build_runner`. Run these steps from the workspace root:

```bash
dart pub get

cd packages/obs_mcp
dart run build_runner build --delete-conflicting-outputs
```

This produces `lib/src/obs_mcp_server.mcp.dart`, which wires up all tool handlers.

### Running the Server

```bash
dart run bin/obs_mcp_server.dart
```

The server communicates over stdio and is designed to be launched by an MCP host.

## Testing with MCP Inspector

The [MCP Inspector](https://github.com/modelcontextprotocol/inspector) (`@modelcontextprotocol/inspector`) is the preferred tool for interactively debugging and testing the server.

1. **Install the inspector globally:**

   ```bash
   npm install -g @modelcontextprotocol/inspector
   ```

2. **Launch the inspector connected to the server:**

   ```bash
   cd packages/obs_mcp
   npx @modelcontextprotocol/inspector dart run bin/obs_mcp_server.dart
   ```

3. **Browse and invoke tools** in the web UI that opens automatically. You can inspect request/response payloads for each tool call.

4. **Provide connection credentials** by placing a `.env` file in the `packages/obs_mcp/` or `packages/obs_mcp/bin/` directory with your `OBS_WEBSOCKET_URL` and `OBS_WEBSOCKET_PASSWORD` values.

## MCP Host Configuration

Add the following to your MCP host configuration to register the `obs_mcp` server.

### Claude Desktop

Add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "obs": {
      "command": "dart",
      "args": ["run", "bin/obs_mcp_server.dart"],
      "cwd": "/path/to/obs_websocket_workspace/packages/obs_mcp",
      "env": {
        "OBS_WEBSOCKET_URL": "ws://localhost:4455",
        "OBS_WEBSOCKET_PASSWORD": "your-password"
      }
    }
  }
}
```

### VS Code

Add to `.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "obs": {
      "command": "dart",
      "args": ["run", "bin/obs_mcp_server.dart"],
      "cwd": "/path/to/obs_websocket_workspace/packages/obs_mcp",
      "env": {
        "OBS_WEBSOCKET_URL": "ws://localhost:4455",
        "OBS_WEBSOCKET_PASSWORD": "your-password"
      }
    }
  }
}
```

Replace `/path/to/obs_websocket_workspace` with the actual path to your workspace, and set `OBS_WEBSOCKET_PASSWORD` to your OBS WebSocket password (or remove it for anonymous connections).

## License

MIT — see the [LICENSE](../../LICENSE) file for details.
