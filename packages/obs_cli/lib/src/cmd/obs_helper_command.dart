import 'dart:convert' show LineSplitter;

import 'package:args/command_runner.dart';
import 'package:obs_websocket/obs_websocket.dart' show ObsUtil, ObsWebSocket;
import 'package:universal_io/io.dart';

abstract class ObsHelperCommand extends Command<void> {
  ObsWebSocket? _obs;

  ObsWebSocket get obs => _obs!;

  Future<void> initializeObs() async {
    // Try to connect using .env file or environment variables
    _obs = await ObsWebSocket.connectFromEnv(
      timeout: Duration(
        seconds: globalResults?['timeout'] == null
            ? 5
            : int.parse(globalResults!['timeout']),
      ),
      logOptions: ObsUtil.convertToLogOptions(globalResults!['log-level']),
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

  /// Load environment variables from bin/.env file
  Map<String, String> loadEnvFromBin() {
    final envFile = File('bin/.env');

    if (!envFile.existsSync()) {
      throw UsageException(
        'bin/.env file not found at ${envFile.absolute.path}. '
        'Run the CLI from the directory containing bin/.env, or create one '
        'from .env.example.',
        usage,
      );
    }

    return parseDotenv(envFile.readAsStringSync());
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
}
