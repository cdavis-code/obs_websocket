# obs_mcp Example

This example demonstrates how to run the obs_mcp server and use it with an MCP client.

## Prerequisites

- OBS Studio installed and running
- obs-websocket plugin enabled (Settings → Tools → obs-websocket)
- Dart SDK installed

## Setup

### 1. Configure OBS WebSocket

1. Open OBS Studio
2. Go to **Tools** → **obs-websocket Settings**
3. Enable the WebSocket server
4. Set a password (e.g., `your-password`)
5. Note the port (default: `4455`)

### 2. Set Environment Variables

Create a `.env` file or set environment variables:

```bash
export OBS_WEBSOCKET_URL=ws://localhost:4455
export OBS_WEBSOCKET_PASSWORD=your-password
```

Or create a `.env` file in the directory where you'll run the server:

```env
OBS_WEBSOCKET_URL=ws://localhost:4455
OBS_WEBSOCKET_PASSWORD=your-password
```

## Running the MCP Server

### Option 1: Global Activation (Recommended)

```bash
# Install globally
dart pub global activate obs_mcp

# Run the server
obs_mcp
```

### Option 2: Run from Source

```bash
# Get dependencies
dart pub get

# Run the server
dart run bin/obs_mcp_server.dart
```

## Using with MCP Clients

Once the server is running, it communicates via STDIO (standard input/output). Connect to it using any MCP-compatible client.

### Example: Using with MCP Inspector

```bash
# Install and run MCP Inspector
npx @modelcontextprotocol/inspector obs_mcp
```

The inspector will show all available tools and allow you to test them.

### Example: Using with Qoder IDE

Add to your `.qoder/mcp.json`:

```json
{
  "mcpServers": {
    "obs": {
      "command": "obs_mcp"
    }
  }
}
```

Or if running from source:

```json
{
  "mcpServers": {
    "obs": {
      "command": "dart",
      "args": ["run", "bin/obs_mcp_server.dart"],
      "cwd": "/path/to/packages/obs_mcp"
    }
  }
}
```

## Available Tools

After connecting, you'll have access to 60+ OBS control tools including:

- **Inputs**: Create, remove, rename, configure inputs
- **Scenes**: List, create, switch scenes
- **Scene Items**: Add, remove, transform scene items
- **Streaming**: Start, stop streaming
- **Recording**: Start, stop, pause, resume recording
- **Transitions**: Configure and trigger transitions
- **Filters**: Create, configure, reorder filters
- **Outputs**: Control streaming and recording outputs
- **Canvases**: List configured canvases (v5.7.0+)

## Example Tool Calls

Once connected via an MCP client, you can call tools like:

```json
// Get OBS version
{
  "method": "tools/call",
  "params": {
    "name": "obs_get_version",
    "arguments": {}
  }
}

// List all scenes
{
  "method": "tools/call",
  "params": {
    "name": "scenes_list",
    "arguments": {}
  }
}

// Start streaming
{
  "method": "tools/call",
  "params": {
    "name": "stream_start",
    "arguments": {}
  }
}
```

## Troubleshooting

### Connection Failed

- Verify OBS is running
- Check that obs-websocket is enabled in OBS
- Verify the URL and password in your environment variables
- Check firewall settings if OBS is on a different machine

### Tools Not Appearing

- Ensure the server started successfully (check for error messages)
- Verify environment variables are set before starting the server
- Try running with `dart run bin/obs_mcp_server.dart` to see detailed logs

### Authentication Error

- Double-check the password in your environment variables
- Ensure the password matches what's set in OBS WebSocket settings
- Passwords are case-sensitive

## Learn More

- [obs_mcp README](../README.md) - Full documentation
- [obs_websocket](https://pub.dev/packages/obs_websocket) - Underlying library
- [OBS WebSocket Protocol](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md) - Protocol specification
