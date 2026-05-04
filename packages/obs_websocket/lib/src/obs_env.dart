import 'package:envied/envied.dart';

part 'obs_env.g.dart';

/// OBS WebSocket connection configuration loaded from environment variables
/// or `.env` file.
///
/// **Priority order (highest to lowest):**
///   1. System environment variables: `OBS_WEBSOCKET_URL`, `OBS_WEBSOCKET_PASSWORD`,
///      `OBS_WEBSOCKET_TIMEOUT`
///   2. `.env` file in the project root
///
/// **Environment variables:**
/// ```bash
/// export OBS_WEBSOCKET_URL=ws://localhost:4455
/// export OBS_WEBSOCKET_PASSWORD=your_password
/// export OBS_WEBSOCKET_TIMEOUT=120
/// ```
///
/// **`.env` file support:**
/// Place a `.env` file in your project root with:
/// ```env
/// OBS_WEBSOCKET_URL=ws://localhost:4455
/// OBS_WEBSOCKET_PASSWORD=your_password
/// OBS_WEBSOCKET_TIMEOUT=120
/// ```
@Envied(path: '.env', obfuscate: false)
abstract class ObsEnv {
  /// OBS WebSocket server URL (required).
  ///
  /// System environment variable `OBS_WEBSOCKET_URL` takes precedence over .env file.
  @EnviedField(varName: 'OBS_WEBSOCKET_URL')
  static const String url = _ObsEnv.url;

  /// OBS WebSocket password (optional, can be empty).
  ///
  /// System environment variable `OBS_WEBSOCKET_PASSWORD` takes precedence over .env file.
  @EnviedField(varName: 'OBS_WEBSOCKET_PASSWORD', defaultValue: '')
  static const String password = _ObsEnv.password;

  /// Connection timeout in seconds (optional, default: 120).
  ///
  /// System environment variable `OBS_WEBSOCKET_TIMEOUT` takes precedence over .env file.
  @EnviedField(varName: 'OBS_WEBSOCKET_TIMEOUT', defaultValue: '120')
  static const String timeout = _ObsEnv.timeout;
}
