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
}
