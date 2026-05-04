# Installation and Setup

<cite>
**Referenced Files in This Document**
- [README.md](file://README.md)
- [bin/README.md](file://bin/README.md)
- [pubspec.yaml](file://pubspec.yaml)
- [bin/obs.dart](file://bin/obs.dart)
- [example/config.sample.yaml](file://example/config.sample.yaml)
</cite>

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation Methods](#installation-methods)
4. [OBS WebSocket Server Setup](#obs-websocket-server-setup)
5. [Environment Configuration](#environment-configuration)
6. [Verification and Testing](#verification-and-testing)
7. [Common Issues and Solutions](#common-issues-and-solutions)
8. [Operating System Notes](#operating-system-notes)
9. [Package Manager Notes](#package-manager-notes)
10. [Troubleshooting Guide](#troubleshooting-guide)
11. [Conclusion](#conclusion)

## Introduction

This document provides comprehensive installation and setup instructions for the obs_websocket CLI tool. The CLI enables command-line control of OBS (Open Broadcaster Software) through the obs-websocket protocol, allowing automation and integration of streaming workflows.

The CLI tool provides a complete command-line interface for controlling OBS instances remotely, supporting all major obs-websocket protocol features including streams, scenes, inputs, sources, and UI controls.

## Prerequisites

### Dart SDK Requirements

The obs_websocket package requires a specific Dart SDK version:

- **Minimum Dart SDK Version**: 3.8.0
- **Package Version**: 5.2.3+2

This requirement ensures compatibility with the latest Dart language features and maintains stability across platforms.

### OBS Studio Requirements

- **OBS Version**: 27.x or above
- **Network Accessibility**: OBS instance must be reachable on the local network
- **obs-websocket Plugin**: Included with OBS in current versions

### Network Requirements

- OBS WebSocket server must be accessible via TCP/IP
- Standard WebSocket protocol (RFC 6455) support
- Port availability for WebSocket connections

**Section sources**
- [pubspec.yaml:10-11](file://pubspec.yaml#L10-L11)
- [README.md:43-46](file://README.md#L43-L46)

## Installation Methods

### Method 1: Dart Pub Global Activation (Recommended)

The primary installation method uses Dart's pub global activation system:

```bash
dart pub global activate obs_websocket
```

This method installs the CLI globally and makes the `obs` command available system-wide.

### Method 2: Homebrew Installation (macOS/Linux)

For users preferring package managers, the tool can be installed via Homebrew:

```bash
# Add the tap
brew tap faithoflifedev/obs_websocket

# Install the package
brew install obs
```

### Verification Steps

After installation, verify the setup:

```bash
# Check help output
obs --help

# Verify version
obs version
```

The help output should display available commands and global options including URI configuration, timeout settings, logging levels, and password handling.

**Section sources**
- [bin/README.md:56-80](file://bin/README.md#L56-L80)
- [README.md:497-507](file://README.md#L497-L507)

## OBS WebSocket Server Setup

### Enabling OBS WebSocket Server

1. **Open OBS Studio** on the target machine
2. **Navigate to Tools Menu**: `Tools > WebSocket Server Settings`
3. **Enable Server**: Check "Enable Web Socket Server"
4. **Configure Port**: Set a suitable port number (default is typically 4455)
5. **Set Password**: Configure authentication password if required

### Password Configuration

The obs_websocket CLI supports two authentication modes:

- **Password Authentication**: Required when OBS WebSocket password is enabled
- **No Password**: Used when OBS WebSocket server operates without authentication

Password configuration in OBS:
- Enable "Enable Password Authentication"
- Set a strong password
- Apply settings and restart OBS if necessary

### Connection Configuration

The CLI accepts connection parameters through several methods:

1. **Command Line Arguments**:
   ```bash
   obs --uri ws://localhost:4455 --passwd your_password general get-version
   ```

2. **Configuration File**: Create an authentication file using the authorize command
3. **Environment Variables**: Set OBS_WS_URI and OBS_WS_PASSWORD environment variables

**Section sources**
- [bin/README.md:165-183](file://bin/README.md#L165-L183)
- [bin/obs.dart:8-33](file://bin/obs.dart#L8-L33)

## Environment Configuration

### Global Options

The obs CLI provides several global configuration options:

- **URI Configuration**: `--uri` or `-u` for WebSocket endpoint
- **Timeout Settings**: `--timeout` or `-t` for connection timeout (seconds)
- **Logging Levels**: `--log-level` or `-l` with options: all, debug, info, warning, error, off
- **Password**: `--passwd` or `-p` for WebSocket authentication

### Configuration File Approach

Use the authorize command to create persistent configuration:

```bash
obs authorize
```

This creates an authentication file containing:
```json
{"uri":"ws://[ip address or hostname]:[port]","password":"[password]"}
```

### Environment Variables

Set these environment variables for persistent configuration:
- `OBS_WS_URI`: WebSocket endpoint URL
- `OBS_WS_PASSWORD`: Authentication password
- `OBS_WS_TIMEOUT`: Connection timeout in seconds

**Section sources**
- [bin/README.md:88-108](file://bin/README.md#L88-L108)
- [bin/obs.dart:8-33](file://bin/obs.dart#L8-L33)

## Verification and Testing

### Basic Connectivity Test

Test the connection to your OBS instance:

```bash
# Basic version check
obs general get-version

# Stream status check
obs stream get-stream-status

# List available scenes
obs scenes get-scenes-list
```

### JSON Output Processing

The CLI outputs JSON responses by default. Use tools like `jq` for parsing:

```bash
# Extract specific fields
obs stream get-stream-status | jq -r '.outputActive'

# Pretty print JSON
obs general get-version | jq
```

### Connection Validation

Verify successful connection with:

```bash
# Check if OBS is reachable
obs general get-stats

# Verify authentication (if password required)
obs --passwd your_password general get-version
```

### Network Troubleshooting

If connection fails, verify:

1. **Network Reachability**: `ping obs-host-ip`
2. **Port Availability**: `telnet obs-host-ip 4455`
3. **Firewall Settings**: Ensure port 4455 is open
4. **OBS WebSocket Status**: Confirm server is running in OBS

**Section sources**
- [bin/README.md:127-161](file://bin/README.md#L127-L161)
- [README.md:516-536](file://README.md#L516-L536)

## Common Issues and Solutions

### Dart SDK Version Mismatch

**Problem**: Installation fails due to incompatible Dart SDK version

**Solution**: Upgrade to Dart SDK 3.8.0 or later
```bash
# Check current version
dart --version

# Update Dart SDK according to your platform
```

### OBS WebSocket Not Responding

**Problem**: CLI cannot connect to OBS WebSocket server

**Solutions**:
1. Verify OBS WebSocket server is enabled in OBS
2. Check port accessibility (default: 4455)
3. Ensure firewall allows incoming connections
4. Restart OBS after enabling WebSocket server

### Authentication Failures

**Problem**: Connection rejected due to incorrect password

**Solutions**:
1. Verify password matches OBS WebSocket configuration
2. Check if password authentication is enabled in OBS
3. Use the authorize command to create proper credentials
4. Test with explicit password parameter

### Network Connectivity Issues

**Problem**: Cannot reach OBS instance from client machine

**Solutions**:
1. Use IP address instead of localhost for remote connections
2. Configure OBS WebSocket to accept connections from remote hosts
3. Check network routing between client and OBS host
4. Verify firewall rules allow WebSocket traffic

### Package Manager Installation Problems

**Problem**: Homebrew installation fails or command not found

**Solutions**:
1. Ensure Homebrew is properly installed and updated
2. Run `brew tap faithoflifedev/obs_websocket` before installation
3. Check PATH environment variable includes Homebrew bin directory
4. Reinstall if package appears corrupted

**Section sources**
- [pubspec.yaml:10-11](file://pubspec.yaml#L10-L11)
- [bin/README.md:56-80](file://bin/README.md#L56-L80)

## Operating System Notes

### Windows Installation

- **PowerShell**: Use PowerShell as administrator for global activation
- **Command Prompt**: May require elevated privileges
- **PATH Configuration**: Ensure Dart SDK bin directory is in PATH
- **Windows Firewall**: Allow outbound connections on WebSocket port

### macOS Installation

- **Homebrew**: Preferred method for package management
- **Xcode Command Line Tools**: Required for native compilation
- **Security Permissions**: May require granting permissions for network access
- **Rosetta**: ARM64 Macs may need Rosetta for Intel packages

### Linux Installation

- **Package Managers**: Use distribution-specific package managers
- **Dependencies**: Install required system libraries
- **Permissions**: Ensure user has permission to bind to network ports
- **Systemd**: Consider systemd service for persistent WebSocket server

### Cross-Platform Considerations

- **Network Configuration**: Different platforms may have varying firewall behaviors
- **File Permissions**: Authentication files require appropriate permissions
- **Path Separators**: Use forward slashes in URIs regardless of platform
- **Case Sensitivity**: File paths are case-sensitive on Unix-like systems

## Package Manager Notes

### Dart Pub Global

**Advantages**:
- Direct access to latest package versions
- No additional dependencies required
- Platform-independent installation

**Setup Requirements**:
- Dart SDK 3.8.0 or later
- Proper PATH configuration
- Internet connectivity for package download

### Homebrew (macOS/Linux)

**Advantages**:
- Automatic dependency management
- System-wide installation
- Easy updates and removal

**Setup Requirements**:
- Homebrew installed and updated
- Tap added before installation
- Appropriate permissions for system-wide installation

### Alternative Package Managers

Consider these alternatives based on your environment:

- **Chocolatey** (Windows): `choco install dart`
- **Snap** (Linux): `sudo snap install dart`
- **AppImage** (Cross-platform): Downloadable portable version

## Troubleshooting Guide

### Installation Troubleshooting

**Issue**: `dart pub global activate` fails
- Check Dart SDK installation and PATH
- Verify internet connectivity
- Clear pub cache: `dart pub cache repair`

**Issue**: `obs` command not found
- Verify PATH includes Dart's bin directory
- Restart terminal/shell session
- Check for conflicting installations

### Connection Troubleshooting

**Issue**: Connection timeout
- Increase timeout value: `--timeout 30`
- Check network latency between client and OBS host
- Verify OBS WebSocket server is running

**Issue**: Authentication errors
- Verify password matches OBS configuration
- Check if password authentication is enabled
- Use `obs authorize` to create proper credentials

### Performance Troubleshooting

**Issue**: Slow response times
- Reduce log level to `error` or `off`
- Limit event subscriptions for `obs listen`
- Close unused connections

**Issue**: Memory usage increases over time
- Ensure proper cleanup of connections
- Monitor for memory leaks in scripts
- Restart OBS if necessary

### Debugging Commands

Use these commands for detailed debugging:

```bash
# Enable verbose logging
obs --log-level debug general get-version

# Test with minimal configuration
obs --uri ws://localhost:4455 general get-stats

# Check network connectivity
obs --timeout 5 general get-version
```

**Section sources**
- [bin/README.md:56-80](file://bin/README.md#L56-L80)
- [bin/obs.dart:22-27](file://bin/obs.dart#L22-L27)

## Conclusion

The obs_websocket CLI provides powerful command-line control over OBS through the obs-websocket protocol. With proper installation and configuration, you can automate streaming workflows, integrate with monitoring systems, and build custom automation scripts.

Key success factors include:
- Correct Dart SDK version compatibility
- Proper OBS WebSocket server configuration
- Network accessibility between client and OBS host
- Appropriate authentication setup
- Platform-specific environment configuration

The CLI offers extensive functionality covering all major OBS features while maintaining simplicity for both basic and advanced use cases. Regular verification of connections and proper error handling ensure reliable operation in production environments.

For ongoing maintenance, keep the obs_websocket package updated and monitor for breaking changes in OBS protocol updates. The comprehensive error handling and logging capabilities provided by the CLI make troubleshooting straightforward and efficient.