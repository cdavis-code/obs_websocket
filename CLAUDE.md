# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Run all tests**: `dart test`
- **Run a specific test**: `dart test <path_to_test_file>`
- **Analyze code**: `dart analyze`
- **Generate code (json_serializable)**: `dart run build_runner build`
- **Run the CLI tool**: `dart run obs <args>`

## Architecture Overview

This package provides a Dart client for the `obs-websocket` protocol, supporting both CLI (`dart:io`) and Web (`dart:html`) environments via conditional imports.

### Key Components

- **`ObsWebSocket`**: The main entry point for developers to interact with OBS.
- **Request Helpers**: Located in `lib/src/request/`, these classes provide high-level, typed methods (e.g., `MediaInputs`) that wrap the low-level JSON-RPC requests.
- **Models**:
  - **Requests/Responses**: Located in `lib/src/model/comm/` and `lib/src/model/response/`.
  - **Events**: A hierarchical model of OBS notifications located in `lib/src/model/event/`.
- **Connection**: Managed via the `Connect` abstraction in `lib/src/connect.dart`, switching between `IoConnect` and `WebConnect` based on the runtime environment.

### Project Structure

- `lib/src/cmd/`: Logic for the `obs` CLI executable.
- `lib/src/model/`: Data models for the protocol (requests, responses, events, enums).
- `lib/src/request/`: High-level API wrappers for specific request categories.
- `lib/src/util/`: Internal utilities and extensions.
