# obs_cli Examples

This directory contains example scripts demonstrating how to use the `obs_cli` command-line tool.

## Setup

Before running these examples, configure your OBS WebSocket credentials:

1. Copy `.env.example` to `.env` in the package root:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your OBS WebSocket URL and password:
   ```env
   OBS_WEBSOCKET_URL=ws://localhost:4455
   OBS_WEBSOCKET_PASSWORD=your_password
   ```

3. Alternatively, set environment variables:
   ```bash
   export OBS_WEBSOCKET_URL=ws://localhost:4455
   export OBS_WEBSOCKET_PASSWORD=your_password
   ```

## Quick Start

### 1. Verify Connection

```bash
# Test your OBS connection
obs authorize
```

Expected output:
```
Validating OBS WebSocket credentials from bin/.env...
✓ Successfully connected to OBS v30.1.2
✓ Credentials are valid

Authorization completed successfully.
Your OBS WebSocket credentials are working correctly.
```

### 2. Check Stream Status

```bash
# Get current stream status
obs stream get-stream-status
```

Output (JSON):
```json
{"outputActive":false,"outputReconnecting":false,"outputTimecode":"00:00:00.000","outputDuration":0}
```

### 3. Parse JSON Output with jq

```bash
# Install jq (macOS)
brew install jq

# Extract just the streaming status
obs stream get-stream-status | jq -r '.outputActive'
```

Output:
```
false
```

## Common Workflows

### Basic Scene Management

```bash
# List all scenes
obs scenes get-scenes-list | jq -r '.scenes[].sceneName'

# Get current program scene
obs scenes get-current-program-scene | jq -r '.currentProgramSceneName'

# List scene items in a specific scene
obs scene-items get-scene-item-list --scene-name "Scene 1" | jq
```

### Input Control

```bash
# List all inputs
obs inputs get-input-list | jq -r '.inputs[] | "\(.inputName) (\(.inputKind))"'

# Get mute status of an input
obs inputs get-input-mute --inputName "Mic/Aux" | jq -r '.inputMuted'

# Mute an input
obs inputs set-input-mute --inputName "Mic/Aux" --mute

# Unmute an input
obs inputs set-input-mute --inputName "Mic/Aux" --no-mute

# Toggle mute
obs inputs toggle-input-mute --inputName "Mic/Aux"
```

### Stream Control

```bash
# Start streaming
obs stream start-streaming

# Stop streaming
obs stream stop-streaming

# Toggle streaming
obs stream toggle-stream

# Get stream status
obs stream get-stream-status | jq
```

### Recording Management

```bash
# Start recording
obs record start-record

# Stop recording
obs record stop-record

# Pause recording
obs record pause-record

# Resume recording
obs record resume-record

# Split recording file (requires MKV format)
obs record split-record-file

# Create chapter in recording
obs record create-record-chapter --chapterName "Introduction"
```

### Virtual Camera

```bash
# Check virtual cam status
obs outputs get-virtual-cam-status | jq -r '.outputActive'

# Start virtual camera
obs outputs start-virtual-cam

# Stop virtual camera
obs outputs stop-virtual-cam

# Toggle virtual camera
obs outputs toggle-virtual-cam
```

### Replay Buffer

```bash
# Check replay buffer status
obs outputs get-replay-buffer-status | jq

# Start replay buffer
obs outputs start-replay-buffer

# Save replay buffer to disk
obs outputs save-replay-buffer

# Stop replay buffer
obs outputs stop-replay-buffer
```

### Transition Control

```bash
# List available transitions
obs transitions get-scene-transition-list | jq -r '.transitions[].transitionName'

# Get current transition
obs transitions get-current-scene-transition | jq

# Set transition type
obs transitions set-current-scene-transition --transitionName "Fade"

# Set transition duration (500ms)
obs transitions set-current-scene-transition-duration --transitionDuration 500

# Trigger transition (requires Studio Mode)
obs ui set-studio-mode-enabled --studio-mode
obs transitions trigger-studio-mode-transition
```

### Filter Management

```bash
# List available filter kinds
obs filters get-source-filter-kind-list | jq

# Get filters for a source
obs filters get-source-filter-list --sourceName "Video Capture Device" | jq

# Get default settings for a filter kind
obs filters get-source-filter-default-settings --filterKind "color_correction_v2" | jq

# Create a new filter
obs filters create-source-filter \
  --sourceName "Video Capture Device" \
  --filterName "Brightness Boost" \
  --filterKind "color_correction_v2" \
  --filterSettings '{"gamma": 1.5}'

# Update filter settings
obs filters set-source-filter-settings \
  --sourceName "Video Capture Device" \
  --filterName "Brightness Boost" \
  --filterSettings '{"gamma": 2.0}'

# Disable a filter
obs filters set-source-filter-enabled \
  --sourceName "Video Capture Device" \
  --filterName "Brightness Boost" \
  --no-filterEnabled

# Remove a filter
obs filters remove-source-filter \
  --sourceName "Video Capture Device" \
  --filterName "Brightness Boost"
```

### Event Monitoring

```bash
# Listen to all scene-related events
obs listen --event-subscriptions scenes

# Parse scene events with jq
obs listen --event-subscriptions scenes | jq -r '.eventType + "\t" + .eventData.sceneName'

# Listen to input events
obs listen --event-subscriptions inputs

# Listen to stream state changes
obs listen --event-subscriptions outputs

# Listen to multiple event types
obs listen --event-subscriptions scenes,inputs,outputs
```

### Advanced: Trigger Shell Commands on Events

```bash
# Send email notification on scene change
obs listen --event-subscriptions scenes \
  --command 'mutt -s "OBS Scene Changed" your@email.com'

# Log events to a file
obs listen --event-subscriptions all \
  --command 'tee -a /tmp/obs_events.log'

# Desktop notification on macOS
obs listen --event-subscriptions outputs \
  --command 'osascript -e "display notification \"Stream state changed\" with title \"OBS Event\""'
```

### Screenshot Capture

```bash
# Get screenshot as base64
obs sources get-source-screenshot \
  --source-name "Game Capture" \
  --image-format "png" | jq -r '.imageData'

# Save screenshot to file
obs sources save-source-screenshot \
  --source-name "Game Capture" \
  --image-format "png" \
  --image-file-path "/tmp/screenshot.png"
```

### System Information

```bash
# Get OBS version
obs general get-version | jq

# Get OBS statistics
obs general get-stats | jq

# Get video settings
obs config get-video-settings | jq

# Get record directory
obs config get-record-directory | jq -r '.recordDirectory'
```

## Scripting Examples

### Bash Script: Auto-start Stream and Recording

```bash
#!/bin/bash
# auto-stream.sh

echo "Starting OBS stream and recording..."

# Start recording
obs record start-record
echo "Recording started"

# Wait 2 seconds
sleep 2

# Start streaming
obs stream start-streaming
echo "Streaming started"

# Monitor status
while true; do
  status=$(obs stream get-stream-status | jq -r '.outputActive')
  if [ "$status" = "false" ]; then
    echo "Stream ended at $(date)"
    obs record stop-record
    echo "Recording stopped"
    exit 0
  fi
  sleep 10
done
```

### Bash Script: Scene Switcher with Delay

```bash
#!/bin/bash
# scene-switcher.sh

echo "Switching to 'Starting Soon' scene..."
# Use obs send for scene change (low-level command)
obs send --command SetCurrentProgramScene \
  --args '{"sceneName": "Starting Soon"}'

# Wait 30 seconds
sleep 30

echo "Switching to 'Main' scene..."
obs send --command SetCurrentProgramScene \
  --args '{"sceneName": "Main"}'

echo "Done!"
```

### Python Integration

```python
#!/usr/bin/env python3
# obs-monitor.py
import subprocess
import json
import time

def get_stream_status():
    result = subprocess.run(
        ['obs', 'stream', 'get-stream-status'],
        capture_output=True,
        text=True
    )
    return json.loads(result.stdout)

def main():
    print("Monitoring OBS stream...")
    while True:
        status = get_stream_status()
        active = status.get('outputActive', False)
        
        if active:
            duration = status.get('outputDuration', 0)
            print(f"Stream active for {duration}ms")
        else:
            print("Stream is not active")
        
        time.sleep(5)

if __name__ == '__main__':
    main()
```

## Using with jq

The `jq` tool is essential for parsing JSON output from obs_cli. Here are common patterns:

```bash
# Extract a single value
obs stream get-stream-status | jq -r '.outputActive'

# Extract multiple values
obs general get-stats | jq -r '{cpu: .cpuUsage, memory: .memoryUsage}'

# List all scene names
obs scenes get-scenes-list | jq -r '.scenes[].sceneName'

# Filter inputs by type
obs inputs get-input-list | jq -r '.inputs[] | select(.inputKind == "ffmpeg_source") | .inputName'

# Pretty print with colors
obs general get-stats | jq '.'

# Count scenes
obs scenes get-scenes-list | jq '.scenes | length'
```

## Troubleshooting

### Connection Refused

```bash
# Check if OBS is running
ps aux | grep OBS

# Verify WebSocket is enabled in OBS
# Tools → WebSocket Server Settings → Enable WebSocket Server

# Test connection manually
obs authorize
```

### Authentication Failed

```bash
# Verify password in .env file
cat .env | grep OBS_WEBSOCKET_PASSWORD

# Test with explicit password
obs --passwd "your_password" stream get-stream-status
```

### Command Not Found

```bash
# If installed via dart pub
dart pub global run obs:stream get-stream-status

# Ensure dart bin is in PATH
export PATH="$HOME/.pub-cache/bin:$PATH"
```

## Additional Resources

- **Full Documentation**: [obs_cli README](../README.md)
- **OBS WebSocket Protocol**: [GitHub](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md)
- **jq Manual**: [stedolan.github.io/jq](https://stedolan.github.io/jq/)
