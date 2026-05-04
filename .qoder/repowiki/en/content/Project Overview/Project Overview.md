# Project Overview

<cite>
**Referenced Files in This Document**
- [README.md](file://README.md)
- [pubspec.yaml](file://pubspec.yaml)
- [lib/obs_websocket.dart](file://lib/obs_websocket.dart)
- [lib/request.dart](file://lib/request.dart)
- [lib/event.dart](file://lib/event.dart)
- [lib/command.dart](file://lib/command.dart)
- [lib/src/obs_websocket_base.dart](file://lib/src/obs_websocket_base.dart)
- [lib/src/connect.dart](file://lib/src/connect.dart)
- [lib/src/request/general.dart](file://lib/src/request/general.dart)
- [lib/src/request/scenes.dart](file://lib/src/request/scenes.dart)
- [lib/src/request/stream.dart](file://lib/src/request/stream.dart)
- [lib/src/request/scene_items.dart](file://lib/src/request/scene_items.dart)
- [lib/src/cmd/obs_general_command.dart](file://lib/src/cmd/obs_general_command.dart)
- [lib/src/cmd/obs_listen_command.dart](file://lib/src/cmd/obs_listen_command.dart)
- [bin/obs.dart](file://bin/obs.dart)
- [example/general.dart](file://example/general.dart)
- [example/event.dart](file://example/event.dart)
</cite>

## Table of Contents
1. [Introduction](#introduction)
2. [Project Structure](#project-structure)
3. [Core Components](#core-components)
4. [Architecture Overview](#architecture-overview)
5. [Detailed Component Analysis](#detailed-component-analysis)
6. [Dependency Analysis](#dependency-analysis)
7. [Performance Considerations](#performance-considerations)
8. [Troubleshooting Guide](#troubleshooting-guide)
9. [Conclusion](#conclusion)

## Introduction
obs-websocket-dart is a Dart library that provides complete control over OBS (Open Broadcaster Software) using the obs-websocket 5.x protocol. It enables Dart and Flutter developers to automate and integrate with OBS remotely via a WebSocket connection, supporting both high-level helper methods and a low-level request system. The library offers robust event subscription, a CLI for command-line control, and comprehensive coverage of the protocol’s requests and events.

Key highlights:
- WebSocket-based control of OBS with automatic authentication and handshake
- Complete protocol implementation aligned with obs-websocket 5.x
- Event subscription system for real-time updates
- High-level helper methods for common requests
- CLI interface for scripting and automation tasks

Target audience:
- Dart and Flutter developers building broadcasting tools, stream automation systems, and OBS control applications

Common use cases:
- Stream automation (start/stop streams, toggle recording, manage transitions)
- OBS control applications (remote UIs, dashboards, and integrations)
- Broadcasting tools (captions, overlays, and dynamic scene management)

Breaking changes from v4.9.1 to v5.x:
- The v5.x protocol introduces significant architectural and behavioral changes compared to v4.9.1. Any code written for the older protocol requires rewriting for v5.x compatibility.

## Project Structure
The project is organized into libraries, request modules, event models, command-line interface, and examples. The main entry points expose high-level APIs and a CLI executable.

```mermaid
graph TB
subgraph "Library Exports"
LWS["lib/obs_websocket.dart"]
REQ["lib/request.dart"]
EVT["lib/event.dart"]
CMD["lib/command.dart"]
end
subgraph "Core Implementation"
BASE["lib/src/obs_websocket_base.dart"]
CONNECT["lib/src/connect.dart"]
end
subgraph "Request Modules"
GEN["lib/src/request/general.dart"]
SCN["lib/src/request/scenes.dart"]
STR["lib/src/request/stream.dart"]
SI["lib/src/request/scene_items.dart"]
end
subgraph "CLI"
BIN["bin/obs.dart"]
OGC["lib/src/cmd/obs_general_command.dart"]
OLC["lib/src/cmd/obs_listen_command.dart"]
end
subgraph "Examples"
EX1["example/general.dart"]
EX2["example/event.dart"]
end
LWS --> BASE
REQ --> GEN
REQ --> SCN
REQ --> STR
REQ --> SI
CMD --> OGC
CMD --> OLC
BIN --> CMD
EX1 --> LWS
EX2 --> LWS
```

**Diagram sources**
- [lib/obs_websocket.dart:1-68](file://lib/obs_websocket.dart#L1-L68)
- [lib/request.dart:1-19](file://lib/request.dart#L1-L19)
- [lib/event.dart:1-50](file://lib/event.dart#L1-L50)
- [lib/command.dart:1-20](file://lib/command.dart#L1-L20)
- [lib/src/obs_websocket_base.dart:1-428](file://lib/src/obs_websocket_base.dart#L1-L428)
- [lib/src/connect.dart:1-15](file://lib/src/connect.dart#L1-L15)
- [lib/src/request/general.dart:1-143](file://lib/src/request/general.dart#L1-L143)
- [lib/src/request/scenes.dart:1-232](file://lib/src/request/scenes.dart#L1-L232)
- [lib/src/request/stream.dart:1-94](file://lib/src/request/stream.dart#L1-L94)
- [lib/src/request/scene_items.dart:1-324](file://lib/src/request/scene_items.dart#L1-L324)
- [lib/src/cmd/obs_general_command.dart:1-306](file://lib/src/cmd/obs_general_command.dart#L1-L306)
- [lib/src/cmd/obs_listen_command.dart:1-123](file://lib/src/cmd/obs_listen_command.dart#L1-L123)
- [bin/obs.dart:1-57](file://bin/obs.dart#L1-L57)
- [example/general.dart:1-152](file://example/general.dart#L1-L152)
- [example/event.dart:1-44](file://example/event.dart#L1-L44)

**Section sources**
- [README.md:37-106](file://README.md#L37-L106)
- [pubspec.yaml:1-38](file://pubspec.yaml#L1-L38)
- [lib/obs_websocket.dart:1-68](file://lib/obs_websocket.dart#L1-L68)
- [lib/request.dart:1-19](file://lib/request.dart#L1-L19)
- [lib/event.dart:1-50](file://lib/event.dart#L1-L50)
- [lib/command.dart:1-20](file://lib/command.dart#L1-L20)
- [bin/obs.dart:1-57](file://bin/obs.dart#L1-L57)

## Core Components
- WebSocket client: Establishes and manages the WebSocket connection, handles authentication, and routes messages.
- Request system: Provides high-level helper methods grouped by functional domains (General, Scenes, Stream, Scene Items, etc.) and a low-level send method for arbitrary requests.
- Event management: Supports subscribing to event categories, dispatching typed events to handlers, and a fallback mechanism for unsupported events.
- CLI interface: Offers a command-line tool to control OBS, including general commands, listening to events, and sending low-level requests.

Practical examples:
- Connect to OBS, subscribe to events, and toggle streaming using high-level helpers.
- Use the CLI to broadcast custom events to the obs-browser plugin.
- Subscribe to input volume meters and react to scene changes in real time.

**Section sources**
- [README.md:106-490](file://README.md#L106-L490)
- [lib/src/obs_websocket_base.dart:11-428](file://lib/src/obs_websocket_base.dart#L11-L428)
- [lib/src/request/general.dart:1-143](file://lib/src/request/general.dart#L1-L143)
- [lib/src/request/scenes.dart:1-232](file://lib/src/request/scenes.dart#L1-L232)
- [lib/src/request/stream.dart:1-94](file://lib/src/request/stream.dart#L1-L94)
- [lib/src/request/scene_items.dart:1-324](file://lib/src/request/scene_items.dart#L1-L324)
- [lib/src/cmd/obs_general_command.dart:1-306](file://lib/src/cmd/obs_general_command.dart#L1-L306)
- [lib/src/cmd/obs_listen_command.dart:1-123](file://lib/src/cmd/obs_listen_command.dart#L1-L123)
- [example/general.dart:1-152](file://example/general.dart#L1-L152)
- [example/event.dart:1-44](file://example/event.dart#L1-L44)

## Architecture Overview
The library follows a layered architecture:
- Export layer: Public APIs and model exports
- Core layer: WebSocket client, authentication, request/response handling, and event routing
- Feature layer: Request modules for each domain (General, Scenes, Stream, etc.)
- CLI layer: Command runner and commands for general operations and event listening

```mermaid
graph TB
Client["Client Code<br/>Dart/Flutter App"] --> API["Public API<br/>lib/obs_websocket.dart"]
API --> Core["Core Client<br/>lib/src/obs_websocket_base.dart"]
Core --> WS["WebSocket Channel<br/>web_socket_channel"]
Core --> Req["Request Modules<br/>lib/request.dart"]
Core --> Ev["Event Handlers<br/>lib/event.dart"]
Core --> Conn["Connection Factory<br/>lib/src/connect.dart"]
subgraph "Request Modules"
Gen["General"]
Scn["Scenes"]
Str["Stream"]
Si["Scene Items"]
end
Req --> Gen
Req --> Scn
Req --> Str
Req --> Si
subgraph "CLI"
Bin["bin/obs.dart"]
Cmd["Commands<br/>lib/command.dart"]
end
Bin --> Cmd
Cmd --> Gen
Cmd --> Scn
Cmd --> Str
Cmd --> Si
```

**Diagram sources**
- [lib/obs_websocket.dart:1-68](file://lib/obs_websocket.dart#L1-L68)
- [lib/src/obs_websocket_base.dart:1-428](file://lib/src/obs_websocket_base.dart#L1-L428)
- [lib/request.dart:1-19](file://lib/request.dart#L1-L19)
- [lib/event.dart:1-50](file://lib/event.dart#L1-L50)
- [lib/src/connect.dart:1-15](file://lib/src/connect.dart#L1-L15)
- [bin/obs.dart:1-57](file://bin/obs.dart#L1-L57)
- [lib/command.dart:1-20](file://lib/command.dart#L1-L20)

## Detailed Component Analysis

### WebSocket Client and Handshake
The core client initializes a WebSocket channel, performs the obs-websocket handshake, authenticates (if required), and sets up event and request handling.

```mermaid
sequenceDiagram
participant App as "Client App"
participant Client as "ObsWebSocket"
participant WS as "WebSocketChannel"
App->>Client : "connect(url, password)"
Client->>WS : "open connection"
WS-->>Client : "Hello opcode"
Client->>Client : "authenticate()"
Client->>WS : "Identify opcode"
WS-->>Client : "Identified opcode"
Client->>Client : "store negotiatedRpcVersion"
Client->>WS : "subscribe to events (optional)"
WS-->>Client : "Event opcodes"
Client->>App : "dispatch to handlers"
```

**Diagram sources**
- [lib/src/obs_websocket_base.dart:135-236](file://lib/src/obs_websocket_base.dart#L135-L236)
- [lib/src/connect.dart:1-15](file://lib/src/connect.dart#L1-L15)

**Section sources**
- [lib/src/obs_websocket_base.dart:11-428](file://lib/src/obs_websocket_base.dart#L11-L428)
- [lib/src/connect.dart:1-15](file://lib/src/connect.dart#L1-L15)

### Request System
High-level request modules encapsulate protocol requests into typed methods. Each module exposes getters and methods that internally call the core sendRequest mechanism.

```mermaid
classDiagram
class ObsWebSocket {
+send(command, args)
+sendRequest(request)
+sendBatch(requests)
+subscribe(mask)
+addHandler(handler)
+removeHandler(handler)
+close()
}
class General {
+version
+stats
+broadcastCustomEvent(args)
+callVendorRequest(vendorName, requestType, requestData)
+obsBrowserEvent(eventName, eventData)
+hotkeyList
+triggerHotkeyByName(name)
+triggerHotkeyByKeySequence(keyId, keyModifiers)
+sleep(millis, frames)
}
class Scenes {
+list()
+groupList()
+getCurrentProgram()
+setCurrentProgram(name)
+getCurrentPreview()
+setCurrentPreview(name)
+create(name)
+remove(name)
+set(name)
+getSceneSceneTransitionOverride(name)
+setSceneSceneTransitionOverride(name, transitionName, transitionDuration)
}
class Stream {
+status
+toggle()
+start()
+stop()
+sendStreamCaption(text)
}
class SceneItems {
+list(sceneName)
+groupList(sceneName)
+getSceneItemId(sceneName, sourceName, offset)
+getEnabled(sceneName, itemId)
+setEnabled(sceneItemEnableStateChanged)
+getLocked(sceneName, itemId)
+setLocked(sceneName, itemId, locked)
+getIndex(sceneName, itemId)
+setIndex(sceneName, itemId, index)
}
ObsWebSocket --> General : "exposes"
ObsWebSocket --> Scenes : "exposes"
ObsWebSocket --> Stream : "exposes"
ObsWebSocket --> SceneItems : "exposes"
```

**Diagram sources**
- [lib/src/obs_websocket_base.dart:351-418](file://lib/src/obs_websocket_base.dart#L351-L418)
- [lib/src/request/general.dart:1-143](file://lib/src/request/general.dart#L1-L143)
- [lib/src/request/scenes.dart:1-232](file://lib/src/request/scenes.dart#L1-L232)
- [lib/src/request/stream.dart:1-94](file://lib/src/request/stream.dart#L1-L94)
- [lib/src/request/scene_items.dart:1-324](file://lib/src/request/scene_items.dart#L1-L324)

**Section sources**
- [lib/src/obs_websocket_base.dart:351-418](file://lib/src/obs_websocket_base.dart#L351-L418)
- [lib/src/request/general.dart:1-143](file://lib/src/request/general.dart#L1-L143)
- [lib/src/request/scenes.dart:1-232](file://lib/src/request/scenes.dart#L1-L232)
- [lib/src/request/stream.dart:1-94](file://lib/src/request/stream.dart#L1-L94)
- [lib/src/request/scene_items.dart:1-324](file://lib/src/request/scene_items.dart#L1-L324)

### Event Management
The client supports subscribing to event masks, dispatching typed events to registered handlers, and falling back to a generic handler for unsupported events.

```mermaid
flowchart TD
Start(["Subscribe to Events"]) --> Mask["Compute Event Subscription Mask"]
Mask --> Send["Send Re-Identify Opcode"]
Send --> Listen["Listen for Event OpCodes"]
Listen --> Type{"Event Type Known?"}
Type --> |Yes| Dispatch["Deserialize and Dispatch to Typed Handler"]
Type --> |No| Fallback["Invoke Fallback Handler(s)"]
Dispatch --> End(["Handlers Executed"])
Fallback --> End
```

**Diagram sources**
- [lib/src/obs_websocket_base.dart:266-349](file://lib/src/obs_websocket_base.dart#L266-L349)
- [lib/event.dart:1-50](file://lib/event.dart#L1-L50)

**Section sources**
- [lib/src/obs_websocket_base.dart:266-349](file://lib/src/obs_websocket_base.dart#L266-L349)
- [lib/event.dart:1-50](file://lib/event.dart#L1-L50)

### CLI Interface
The CLI provides commands for general operations, listening to events, and sending low-level requests. It integrates with the command modules and the core client.

```mermaid
sequenceDiagram
participant User as "User"
participant CLI as "obs CLI"
participant Runner as "CommandRunner"
participant Cmd as "ObsGeneralCommand"
participant Client as "ObsWebSocket"
User->>CLI : "obs general get-version"
CLI->>Runner : "parse args"
Runner->>Cmd : "execute"
Cmd->>Client : "initialize and connect"
Client-->>Cmd : "return version response"
Cmd-->>User : "print response"
Cmd->>Client : "close()"
```

**Diagram sources**
- [bin/obs.dart:1-57](file://bin/obs.dart#L1-L57)
- [lib/src/cmd/obs_general_command.dart:1-306](file://lib/src/cmd/obs_general_command.dart#L1-L306)
- [lib/src/obs_websocket_base.dart:135-172](file://lib/src/obs_websocket_base.dart#L135-L172)

**Section sources**
- [bin/obs.dart:1-57](file://bin/obs.dart#L1-L57)
- [lib/src/cmd/obs_general_command.dart:1-306](file://lib/src/cmd/obs_general_command.dart#L1-L306)
- [lib/src/cmd/obs_listen_command.dart:1-123](file://lib/src/cmd/obs_listen_command.dart#L1-L123)

## Dependency Analysis
External dependencies include web sockets, logging, JSON serialization, and argument parsing for the CLI.

```mermaid
graph TB
Pkg["obs_websocket (pubspec.yaml)"]
WS["web_socket_channel"]
LOG["loggy"]
JSON["json_annotation"]
ARGS["args"]
UUID["uuid"]
VALID["validators"]
YAML["yaml"]
IO["universal_io"]
HTTP["http (dev)"]
Pkg --> WS
Pkg --> LOG
Pkg --> JSON
Pkg --> ARGS
Pkg --> UUID
Pkg --> VALID
Pkg --> YAML
Pkg --> IO
Pkg -. dev .-> HTTP
```

**Diagram sources**
- [pubspec.yaml:10-38](file://pubspec.yaml#L10-L38)

**Section sources**
- [pubspec.yaml:10-38](file://pubspec.yaml#L10-L38)

## Performance Considerations
- Use event subscriptions judiciously; high-volume events (e.g., input volume meters) should be filtered appropriately.
- Batch related requests when possible to reduce round-trips.
- Close the WebSocket connection after use to prevent resource leaks on the OBS instance.

## Troubleshooting Guide
- Authentication failures: Ensure the correct password is provided and that OBS has the obs-websocket plugin configured.
- No events received: Verify the event subscription mask and that listen/subscribe was called before expecting events.
- Low-level request errors: Inspect the request status code and comment returned by the response to diagnose issues.

**Section sources**
- [lib/src/obs_websocket_base.dart:190-236](file://lib/src/obs_websocket_base.dart#L190-L236)
- [lib/src/obs_websocket_base.dart:420-426](file://lib/src/obs_websocket_base.dart#L420-L426)
- [README.md:334-490](file://README.md#L334-L490)

## Conclusion
obs-websocket-dart delivers a comprehensive, protocol-aligned solution for Dart and Flutter developers to control OBS remotely. With a strong WebSocket foundation, rich request modules, robust event handling, and a practical CLI, it supports a wide range of broadcasting and automation scenarios. Developers migrating from v4.9.1 should update their implementations to align with the v5.x protocol.