# OBS WebSocket Examples

This directory contains example Dart applications demonstrating various features of the `obs_websocket` package.

## Quick Start

### Prerequisites

1. OBS Studio v27.x or above with obs-websocket plugin enabled
2. Dart SDK installed
3. OBS running and accessible on the network

### Connection Setup

Create a `.env` file in this directory:
```env
OBS_WEBSOCKET_URL=ws://localhost:4455
OBS_WEBSOCKET_PASSWORD=your_password
```

Or set environment variables:
```bash
export OBS_WEBSOCKET_URL=ws://localhost:4455
export OBS_WEBSOCKET_PASSWORD=your_password
```

**Note:** The `.env` file is parsed at runtime (no build step required). System environment variables take precedence over `.env` file values. This approach works for Dart VM/command-line examples only. For Flutter web/mobile apps, use `ObsWebSocket.connect()` directly with credentials from your app's configuration.

### Running Examples

```bash
# Navigate to the example directory
cd example

# Get dependencies
dart pub get

# Run an example
dart run example.dart
dart run general.dart
dart run event.dart
```

---

## Available Examples

### 1. example.dart - Basic Connection with Environment Variables

**Features:**
- ✅ Connects using `connectFromEnv()` (reads from `.env` or environment variables)
- ✅ Event subscription and handling
- ✅ Scene change event monitoring
- ✅ Exit event handling with graceful shutdown
- ✅ Gets OBS version information
- ✅ Checks stream status

**Best For:** Getting started, understanding basic connection and event handling

**Key Concepts:**
- `ObsWebSocket.connectFromEnv()` - Modern connection approach
- `obs.subscribe(EventSubscription.all)` - Enable event listening
- `obs.addHandler<T>()` - Typed event handlers
- Graceful connection cleanup

---

### 2. general.dart - Comprehensive OBS Operations

**Features:**
- ✅ Connects using `.env` file or environment variables
- ✅ Multiple event handlers (scene changes, volume changes, exit)
- ✅ Configuration operations (get record directory)
- ✅ Canvas list retrieval using raw `send()` method
- ✅ Version and hotkey list retrieval
- ✅ Stream status checking (both helper methods and raw requests)
- ✅ Scene list enumeration
- ✅ Group list management
- ✅ Video settings modification
- ✅ CPU usage statistics
- ✅ Demonstrates both high-level helpers and low-level `send()` method

**Best For:** Learning the full range of OBS operations, understanding helper vs raw methods

**Key Concepts:**
- High-level API: `obs.stream.status`, `obs.scenes.getGroupList()`
- Low-level API: `obs.send('GetStreamStatus')`
- Event subscription with multiple handlers
- Configuration read/write operations

---

### 3. event.dart - Advanced Event Handling

**Features:**
- ✅ Connects using `.env` file or environment variables
- ✅ Combined event subscriptions using bitwise OR
- ✅ Scene name change events
- ✅ Scene list change events
- ✅ Input audio balance change events
- ✅ Input volume meters monitoring (real-time audio levels)
- ✅ Exit event with graceful shutdown

**Best For:** Understanding advanced event subscription patterns, audio monitoring

**Key Concepts:**
- `EventSubscription.all | EventSubscription.inputVolumeMeters` - Combining subscriptions
- Real-time audio level monitoring
- Multiple simultaneous event handlers

---

### 4. batch.dart - Batch Request Operations

**Features:**
- ✅ Connects using `.env` file or environment variables
- ✅ Sends multiple requests in a single batch
- ✅ Processes batch response results
- ✅ Efficient multi-request execution
- ✅ Graceful connection cleanup

**Best For:** Performance optimization, executing multiple requests atomically

**Key Concepts:**
- `obs.sendBatch([Request(...), Request(...)])` - Batch execution
- Request/Response pattern for batch operations
- Error handling for individual requests in batch

---

### 5. show_scene_item.dart - Scene Item Automation

**Features:**
- ✅ Connects using `.env` file or environment variables
- ✅ Gets current program scene
- ✅ Finds scene item ID by source name
- ✅ Monitors scene item enable state changes
- ✅ Automatic scene item visibility toggle with delay
- ✅ Event-driven automation pattern
- ✅ Graceful shutdown after task completion

**Best For:** Understanding scene item manipulation, event-driven automation

**Key Concepts:**
- Scene item identification and manipulation
- Event-driven workflows (show → wait → hide)
- `Future.delayed()` for timed operations
- Conditional event handling

---

### 6. volume.dart - Audio Monitoring

**Features:**
- ✅ Connects using `.env` file or environment variables
- ✅ Real-time input volume change monitoring
- ✅ Input volume meters (audio level visualization data)
- ✅ Displays volume in both multiplier and decibel formats
- ✅ Shows input name and UUID for identification

**Best For:** Audio level monitoring, building audio meters

**Key Concepts:**
- `InputVolumeChanged` event - Volume level changes
- `InputVolumeMeters` event - Real-time audio meter data
- `inputVolumeMul` vs `inputVolumeDb` - Different volume representations
- Continuous event monitoring pattern

---

## Example Categories

### Connection Methods

| Example | Connection Method | Configuration |
|---------|------------------|---------------|
| example.dart | `connectFromEnv()` | `.env` or environment variables |
| general.dart | `connectFromEnv()` | `.env` or environment variables |
| event.dart | `connectFromEnv()` | `.env` or environment variables |
| batch.dart | `connectFromEnv()` | `.env` or environment variables |
| show_scene_item.dart | `connectFromEnv()` | `.env` or environment variables |
| volume.dart | `connectFromEnv()` | `.env` or environment variables |

### Feature Coverage

| Feature | Examples |
|---------|----------|
| Connection & Authentication | All examples |
| Event Handling | example.dart, general.dart, event.dart, show_scene_item.dart, volume.dart |
| Scene Operations | example.dart, general.dart, event.dart, show_scene_item.dart |
| Stream Status | example.dart, general.dart, batch.dart |
| Audio Monitoring | general.dart, event.dart, volume.dart |
| Scene Items | show_scene_item.dart |
| Batch Operations | batch.dart |
| Configuration | general.dart |
| Video Settings | general.dart |
| Canvas Operations | general.dart |

---

## Learning Path

### Beginner (Start Here)
1. **example.dart** - Learn basic connection and event handling
2. **general.dart** - Explore various OBS operations

### Intermediate
3. **event.dart** - Master advanced event subscriptions
4. **volume.dart** - Understand audio monitoring

### Advanced
5. **show_scene_item.dart** - Build event-driven automation
6. **batch.dart** - Optimize with batch operations

---

## Code Patterns

### Modern Pattern (Used in All Examples)
```dart
// Connect using .env or environment variables
final obs = await ObsWebSocket.connectFromEnv();

if (obs == null) {
  print('No OBS connection configured');
  exit(1);
}

// Subscribe to events
await obs.subscribe(EventSubscription.all);

// Add typed event handlers
obs.addHandler<SceneNameChanged>((event) {
  print('Scene changed: ${event.sceneName}');
});

// Use high-level helper methods
final status = await obs.stream.getStreamStatus();
```

---

## Troubleshooting

### Connection Issues
- Ensure OBS is running and WebSocket server is enabled (Tools → obs-websocket Settings)
- Verify the URL and password in your `.env` file or environment variables
- Check that OBS is accessible at the specified address

### Event Handling Not Working
- Make sure to call `await obs.subscribe(EventSubscription.all)` or specific subscriptions
- Events are ignored by default until you subscribe

---

## Additional Resources

- [OBS WebSocket Protocol Documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md)
- [obs_websocket Package README](../README.md)
- [obs_websocket API Reference](https://pub.dev/documentation/obs_websocket/latest/)

---

## Contributing

Feel free to add new examples! When creating a new example:
1. Use descriptive file names (e.g., `scene_transitions.dart`)
2. Add comprehensive comments explaining the features demonstrated
3. Include both modern and legacy patterns if applicable
4. Update this README with your new example
