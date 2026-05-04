# Installation and Setup

<cite>
**Referenced Files in This Document**
- [README.md](file://README.md)
- [pubspec.yaml](file://pubspec.yaml)
- [lib/obs_websocket.dart](file://lib/obs_websocket.dart)
- [lib/src/obs_websocket_base.dart](file://lib/src/obs_websocket_base.dart)
- [lib/src/connect.dart](file://lib/src/connect.dart)
- [lib/src/connect_io.dart](file://lib/src/connect_io.dart)
- [lib/src/connect_html.dart](file://lib/src/connect_html.dart)
- [bin/obs.dart](file://bin/obs.dart)
- [bin/README.md](file://bin/README.md)
- [example/general.dart](file://example/general.dart)
- [example/config.sample.yaml](file://example/config.sample.yaml)
</cite>

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Install Dart SDK](#install-dart-sdk)
4. [Install OBS Studio](#install-obs-studio)
5. [Install obs-websocket Plugin](#install-obs-websocket-plugin)
6. [Configure OBS WebSocket Server](#configure-obs-websocket-server)
7. [Add obs-websocket-dart Dependency](#add-obs-websocket-dart-dependency)
8. [Platform-Specific Notes](#platform-specific-notes)
9. [Step-by-Step Verification](#step-by-step-verification)
10. [Security Considerations](#security-considerations)
11. [Configuration Examples](#configuration-examples)
12. [Troubleshooting](#troubleshooting)
13. [Conclusion](#conclusion)

## Introduction
This guide provides end-to-end installation and setup instructions for using obs-websocket-dart to control OBS Studio remotely via the obs-websocket protocol. It covers prerequisites, dependency installation, OBS configuration, authentication, and verification steps. It also includes platform-specific notes, security guidance, and troubleshooting tips.

## Prerequisites
- Dart SDK: The project requires a Dart SDK meeting the environment constraint defined in the package configuration.
- OBS Studio: Install OBS Studio v27.x or newer on the machine hosting the obs-websocket server.
- obs-websocket Plugin: The obs-websocket plugin is included with OBS in current versions and must be enabled and configured.

**Section sources**
- [README.md:43-56](file://README.md#L43-L56)
- [pubspec.yaml:10-11](file://pubspec.yaml#L10-L11)

## Install Dart SDK
- Install the Dart SDK that satisfies the environment requirement declared in the package configuration.
- After installation, verify your environment by checking the Dart version and ensuring pub is available.

**Section sources**
- [pubspec.yaml:10-11](file://pubspec.yaml#L10-L11)

## Install OBS Studio
- Download and install OBS Studio v27.x or newer from the official website.
- Launch OBS Studio and confirm it runs correctly on your system.

**Section sources**
- [README.md:45-46](file://README.md#L45-L46)

## Install obs-websocket Plugin
- The obs-websocket plugin is included with OBS in current versions.
- Enable the plugin and configure the WebSocket server in OBS as described in the next section.

**Section sources**
- [README.md:45-46](file://README.md#L45-L46)

## Configure OBS WebSocket Server
- Open OBS Studio and navigate to Tools > WebSocket Server Settings.
- Configure the server:
  - Enable the server.
  - Set the port (default is commonly 4455).
  - Optionally enable authentication and set a password.
  - Adjust bind address to control network accessibility (localhost vs. all interfaces).
- Save settings and restart the server if necessary.

Notes:
- The obs-websocket-dart library connects using the ws:// scheme and expects the OBS WebSocket server to be reachable at the configured host and port.
- Authentication is optional; if enabled, provide the password when connecting.

**Section sources**
- [README.md:70-85](file://README.md#L70-L85)
- [README.md:87-89](file://README.md#L87-L89)

## Add obs-websocket-dart Dependency
- Add the obs-websocket-dart package as a dependency in your project’s pubspec file.
- Run your platform’s package manager to fetch dependencies.

Example dependency declaration:
- See the dependency block in the main package configuration for the correct version and usage.

**Section sources**
- [README.md:48-54](file://README.md#L48-L54)
- [pubspec.yaml:13-22](file://pubspec.yaml#L13-L22)

## Platform-Specific Notes
- Dart SDK availability varies by platform; ensure you install the correct SDK for your operating system.
- obs-websocket-dart supports both Dart VM and Dart Web targets:
  - Dart VM (server/desktop): Uses the IO WebSocket channel implementation.
  - Dart Web (browser): Uses the HTML WebSocket channel implementation.
- The library’s connection abstraction selects the appropriate implementation at runtime.

Key implementation files:
- Cross-platform connection interface
- IO (VM) implementation
- HTML (Web) implementation

**Section sources**
- [lib/src/connect.dart:7-14](file://lib/src/connect.dart#L7-L14)
- [lib/src/connect_io.dart:6-18](file://lib/src/connect_io.dart#L6-L18)
- [lib/src/connect_html.dart:5-17](file://lib/src/connect_html.dart#L5-L17)

## Step-by-Step Verification
Follow these steps to verify your setup:

1. Start OBS Studio and confirm the WebSocket server is running with the expected port and authentication settings.
2. Create a minimal Dart script that connects to OBS using the obs-websocket-dart library.
3. Connect to OBS using the ws:// URL and password (if enabled).
4. Send a simple request (for example, get stream status) and verify the response.
5. Subscribe to events and observe event output.
6. Close the connection gracefully.

Reference materials:
- Example script demonstrating connection, event subscription, and basic requests.
- Sample configuration file showing host and password fields.

**Section sources**
- [README.md:72-85](file://README.md#L72-L85)
- [README.md:87-89](file://README.md#L87-L89)
- [example/general.dart:10-17](file://example/general.dart#L10-L17)
- [example/general.dart:19](file://example/general.dart#L19)
- [example/general.dart:76-88](file://example/general.dart#L76-L88)
- [example/config.sample.yaml:1-2](file://example/config.sample.yaml#L1-L2)

## Security Considerations
- Use a strong password for obs-websocket authentication when exposing the server beyond localhost.
- Restrict bind address to localhost if the server is only accessed locally; otherwise, ensure network access is secured.
- Keep OBS Studio and obs-websocket updated to benefit from security patches.
- Avoid embedding secrets in client-side Dart Web applications; prefer server-side scripts for production automation.

**Section sources**
- [README.md:87-89](file://README.md#L87-L89)
- [README.md:70-85](file://README.md#L70-L85)

## Configuration Examples
- Host and password configuration:
  - Use a YAML configuration file or environment variables to store host and password.
  - Reference the sample configuration file for structure and fields.
- Example usage:
  - The example script demonstrates loading configuration, connecting, subscribing to events, and sending requests.

**Section sources**
- [example/config.sample.yaml:1-8](file://example/config.sample.yaml#L1-L8)
- [example/general.dart:8](file://example/general.dart#L8)
- [example/general.dart:10-17](file://example/general.dart#L10-L17)

## Troubleshooting
Common issues and resolutions:
- Connection fails:
  - Verify OBS WebSocket server is running and listening on the configured port.
  - Confirm the host and port in your connection URL match OBS settings.
  - If authentication is enabled, ensure the password matches the one configured in OBS.
- Authentication errors:
  - Ensure the password is provided when connecting and that obs-websocket authentication is enabled in OBS.
- Network accessibility:
  - If connecting from another machine, ensure the bind address and firewall allow inbound connections to the WebSocket port.
- Dart environment:
  - Ensure your Dart SDK meets the required version constraint.

For CLI verification:
- The project includes a CLI tool that can be used to test connectivity and send commands to OBS without writing code.

**Section sources**
- [README.md:70-85](file://README.md#L70-L85)
- [README.md:87-89](file://README.md#L87-L89)
- [bin/README.md:56-80](file://bin/README.md#L56-L80)
- [bin/README.md:165-183](file://bin/README.md#L165-L183)
- [bin/obs.dart:8-33](file://bin/obs.dart#L8-L33)

## Conclusion
You have installed the Dart SDK, confirmed OBS Studio v27.x+, enabled and configured the obs-websocket plugin, added the obs-websocket-dart dependency, and verified connectivity. Use the provided examples and troubleshooting tips to finalize your setup and integrate remote control capabilities into your applications.