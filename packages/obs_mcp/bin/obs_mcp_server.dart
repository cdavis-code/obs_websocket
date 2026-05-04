/// Entry point for the OBS MCP stdio server.
///
/// Delegates to the generated dispatcher in
/// `package:obs_mcp/src/obs_mcp_server.mcp.dart`, first calling
/// [ObsMcpServer.bootstrapFromEnv] so OBS credentials from the environment
/// (or a local `.env` / `bin/.env`) are loaded before the server starts.
///
/// Usage:
///   dart run bin/obs_mcp_server.dart
///
/// Regenerate the MCP dispatcher with:
///   dart run build_runner build
///
/// No post-processing / patch step is required — because the annotated
/// [ObsMcpServer] class lives under `lib/`, the generator emits a runnable
/// `package:` import (not a build-time `asset:` URI).
library;

import 'dart:io' as io;

import 'package:dart_mcp/stdio.dart';
import 'package:obs_mcp/src/obs_mcp_server.dart';
import 'package:obs_mcp/src/obs_mcp_server.mcp.dart';

Future<void> main(List<String> args) async {
  await ObsMcpServer.bootstrapFromEnv();
  final server = MCPServerWithTools(
    stdioChannel(input: io.stdin, output: io.stdout),
  );
  await server.done;
}
