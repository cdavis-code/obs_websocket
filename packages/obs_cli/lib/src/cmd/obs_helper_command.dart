import 'dart:convert' show LineSplitter;

import 'package:args/command_runner.dart';
import 'package:obs_websocket/obs_websocket.dart' show ObsUtil, ObsWebSocket;

abstract class ObsHelperCommand extends Command<void> {
  ObsWebSocket? _obs;

  ObsWebSocket get obs => _obs!;

  Future<void> initializeObs() async {
    // Try to connect using environment variables or .env file
    // Priority: system env vars > .env file in current/parent directories > compile-time ObsEnv
    _obs = await ObsWebSocket.connectFromEnv(
      timeout: Duration(
        seconds: globalResults?['timeout'] == null
            ? 5
            : int.parse(globalResults!['timeout'] as String),
      ),
      logOptions: ObsUtil.convertToLogOptions(
        globalResults!['log-level'] as String,
      ),
    );

    if (_obs == null) {
      throw UsageException(
        'OBS connection information not provided.\n'
        'Set OBS_WEBSOCKET_URL environment variable or create a .env file.\n'
        'See .env.example for the required format.',
        usage,
      );
    }
  }

  /// Minimal dependency-free dotenv parser. Supports KEY=VALUE,
  /// # comments, blank lines, export KEY=VALUE, and single/double-quoted
  /// values. Values are trimmed of surrounding whitespace.
  Map<String, String> parseDotenv(String contents) {
    final result = <String, String>{};
    for (final rawLine in const LineSplitter().convert(contents)) {
      var line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      if (line.startsWith('export ')) line = line.substring(7).trimLeft();
      final eq = line.indexOf('=');
      if (eq <= 0) continue;
      final key = line.substring(0, eq).trim();
      var value = line.substring(eq + 1).trim();
      var wasQuoted = false;
      if (value.length >= 2) {
        final first = value[0];
        final last = value[value.length - 1];
        if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
          value = value.substring(1, value.length - 1);
          wasQuoted = true;
        }
      }
      // Strip trailing inline comments for unquoted values only.
      if (!wasQuoted) {
        final hashIdx = value.indexOf(' #');
        if (hashIdx >= 0) value = value.substring(0, hashIdx).trimRight();
      }
      result[key] = value;
    }
    return result;
  }

  /// Executes a block of code with proper OBS connection cleanup.
  /// Ensures obs.close() is called even if an exception occurs.
  Future<void> withObs(Future<void> Function() block) async {
    await initializeObs();
    try {
      await block();
    } finally {
      await obs.close();
    }
  }
}
