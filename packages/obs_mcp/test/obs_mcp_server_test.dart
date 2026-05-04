@TestOn('vm')
library;

import 'dart:io';

import 'package:obs_mcp/src/obs_mcp_server.dart';
import 'package:test/test.dart';

void main() {
  group('ObsMcpServer.bootstrapFromEnv', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('obs_mcp_test_');
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('is a no-op when no URL is configured', () async {
      // Point at a non-existent dotenv so file lookup finds nothing and
      // Platform.environment likely has no OBS_WEBSOCKET_URL set.
      await expectLater(
        ObsMcpServer.bootstrapFromEnv(
          dotenvPaths: ['${tempDir.path}/missing.env'],
        ),
        completes,
      );
    });

    test('swallows connection errors from invalid URL scheme', () async {
      final envFile = File('${tempDir.path}/.env');
      await envFile.writeAsString(
        'OBS_WEBSOCKET_URL=http://localhost:4455\n'
        'OBS_WEBSOCKET_TIMEOUT=1\n',
      );

      // Invalid scheme triggers ObsArgumentException inside connect() which
      // bootstrapFromEnv must catch and log (to stderr), not rethrow.
      await expectLater(
        ObsMcpServer.bootstrapFromEnv(dotenvPaths: [envFile.path]),
        completes,
      );
    });
  });
}
