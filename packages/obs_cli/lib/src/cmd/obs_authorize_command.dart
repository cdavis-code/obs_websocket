import 'package:obs_cli/src/cmd/obs_helper_command.dart';

/// Validates OBS WebSocket credentials from bin/.env file by attempting
/// a connection to the OBS server.
class ObsAuthorizeCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Validate OBS WebSocket credentials by testing the connection';

  @override
  String get name => 'authorize';

  @override
  Future<void> run() async {
    print('Validating OBS WebSocket credentials...');

    try {
      // Attempt to connect using environment variables or .env file
      await initializeObs();

      // If we get here, the connection was successful
      final version = await obs.general.getVersion();
      print('✓ Successfully connected to OBS v${version.obsVersion}');
      print('✓ Credentials are valid');

      // Close the connection
      await obs.close();

      print('\nAuthorization completed successfully.');
      print('Your OBS WebSocket credentials are working correctly.');
    } on Exception catch (e) {
      print('✗ Connection failed: $e');
      print('\nPlease check your configuration and ensure:');
      print('  1. OBS_WEBSOCKET_URL is correct (e.g., ws://localhost:4455)');
      print('  2. OBS_WEBSOCKET_PASSWORD matches your OBS settings');
      print('  3. OBS is running and WebSocket server is enabled');
      print(
        '  4. A .env file exists in your current directory or parent directories',
      );
      rethrow;
    }
  }
}
