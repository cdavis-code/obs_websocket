import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_websocket/obs_websocket.dart' show ObsUtil;
import 'package:universal_io/io.dart';

/// Generate a refresh token used to authenticate the command line API requests
class ObsAuthorizeCommand extends Command<void> {
  @override
  String get description =>
      'Generate an authentication file for an OBS connection using bin/.env credentials';

  @override
  String get name => 'authorize';

  @override
  void run() async {
    final credFile = File('${ObsUtil.userHome}/.obs/credentials.json');

    final credentials = <String, dynamic>{};

    // Read from bin/.env file
    final envVars = _loadEnvFromBin();

    final uri = envVars['OBS_WEBSOCKET_URL'];
    final password = envVars['OBS_WEBSOCKET_PASSWORD'];

    if (uri == null || uri.isEmpty) {
      throw Exception('Error: OBS_WEBSOCKET_URL not found in bin/.env file.');
    }

    if (password == null || password.isEmpty) {
      throw Exception(
        'Error: OBS_WEBSOCKET_PASSWORD not found in bin/.env file.',
      );
    }

    credentials['uri'] = uri;
    credentials['password'] = password;

    credFile.createSync(recursive: true);

    credFile.writeAsString(json.encode(credentials));

    print('Authorization completed.');
  }

  /// Load environment variables from bin/.env file
  Map<String, String> _loadEnvFromBin() {
    final envFile = File('bin/.env');

    if (!envFile.existsSync()) {
      throw Exception('Error: bin/.env file not found.');
    }

    return _parseDotenv(envFile.readAsStringSync());
  }

  /// Minimal dependency-free dotenv parser. Supports KEY=VALUE,
  /// # comments, blank lines, export KEY=VALUE, and single/double-quoted
  /// values. Values are trimmed of surrounding whitespace.
  Map<String, String> _parseDotenv(String contents) {
    final result = <String, String>{};
    for (final rawLine in const LineSplitter().convert(contents)) {
      var line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      if (line.startsWith('export ')) line = line.substring(7).trimLeft();
      final eq = line.indexOf('=');
      if (eq <= 0) continue;
      final key = line.substring(0, eq).trim();
      var value = line.substring(eq + 1).trim();
      if (value.length >= 2) {
        final first = value[0];
        final last = value[value.length - 1];
        if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
          value = value.substring(1, value.length - 1);
        }
      }
      // Strip trailing inline comments for unquoted values.
      final hashIdx = value.indexOf(' #');
      if (hashIdx >= 0) value = value.substring(0, hashIdx).trimRight();
      result[key] = value;
    }
    return result;
  }
}
