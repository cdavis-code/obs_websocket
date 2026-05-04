import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:loggy/loggy.dart';
import 'package:universal_io/io.dart';

class ObsUtil {
  static LogOptions convertToLogOptions(String logLevel) {
    var logOptions = const LogOptions(LogLevel.info);

    switch (logLevel) {
      case 'all':
        logOptions = const LogOptions(LogLevel.all);
        break;

      case 'debug':
        logOptions = const LogOptions(LogLevel.debug);
        break;

      case 'info':
        logOptions = const LogOptions(LogLevel.info);
        break;

      case 'warning':
        logOptions = const LogOptions(LogLevel.warning);
        break;

      case 'error':
        logOptions = const LogOptions(LogLevel.error);
        break;
    }

    return logOptions;
  }

  static String? get userHome =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  ///A helper function that encrypts authentication info [data] for the purpose
  ///of authentication.
  static String base64Hash(String data) =>
      base64.encode(sha256.convert(utf8.encode(data)).bytes);

  /// Minimal dependency-free dotenv parser. Supports KEY=VALUE,
  /// # comments, blank lines, export KEY=VALUE, and single/double-quoted
  /// values. Values are trimmed of surrounding whitespace.
  ///
  /// **Note:** This only works on Dart VM with file system access.
  static Map<String, String> parseDotenvFile(File file) {
    final result = <String, String>{};
    final contents = file.readAsStringSync();
    final lines = contents.split('\n');

    for (var line in lines) {
      line = line.trim();

      // Skip empty lines and comments
      if (line.isEmpty || line.startsWith('#')) continue;

      // Handle export prefix
      if (line.startsWith('export ')) {
        line = line.substring(7).trimLeft();
      }

      // Find the first = sign
      final eqIndex = line.indexOf('=');
      if (eqIndex <= 0) continue;

      final key = line.substring(0, eqIndex).trim();
      var value = line.substring(eqIndex + 1).trim();

      // Remove surrounding quotes if present
      var wasQuoted = false;
      if (value.length >= 2) {
        final firstChar = value[0];
        final lastChar = value[value.length - 1];
        if ((firstChar == '"' && lastChar == '"') ||
            (firstChar == "'" && lastChar == "'")) {
          value = value.substring(1, value.length - 1);
          wasQuoted = true;
        }
      }

      // Strip trailing inline comments for unquoted values
      if (!wasQuoted) {
        final commentIndex = value.indexOf(' #');
        if (commentIndex >= 0) {
          value = value.substring(0, commentIndex).trimRight();
        }
      }

      result[key] = value;
    }

    return result;
  }
}
