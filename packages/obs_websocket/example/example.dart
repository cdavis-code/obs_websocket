import 'dart:async';
import 'dart:io';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Example demonstrating connection using environment variables or .env file.
///
/// Create a `.env` file in the current directory with:
/// ```env
/// OBS_WEBSOCKET_URL=ws://localhost:4455
/// OBS_WEBSOCKET_PASSWORD=your_password
/// ```
///
/// Or set environment variables:
/// ```bash
/// export OBS_WEBSOCKET_URL=ws://localhost:4455
/// export OBS_WEBSOCKET_PASSWORD=your_password
/// ```
///
/// Note: The .env file is parsed at runtime (no build step required).
void main(List<String> args) async {
  // Connect using .env file or environment variables
  final obs = await ObsWebSocket.connectFromEnv(
    logOptions: const LogOptions(LogLevel.debug),
    fallbackEventHandler: (Event event) =>
        print('Event: ${event.eventType} | Data: ${event.eventData}'),
    onDone: () => print('Connection closed'),
  );

  if (obs == null) {
    print(
      'Error: No OBS connection configured.\n'
      'Set OBS_WEBSOCKET_URL environment variable or create a .env file.',
    );
    exit(1);
  }

  // Subscribe to all events
  await obs.subscribe(EventSubscription.all);

  // Listen for scene changes
  obs.addHandler<SceneNameChanged>(
    (SceneNameChanged event) async {
      print('Scene changed to: ${event.sceneName}');
    },
  );

  // Listen for exit
  obs.addHandler<ExitStarted>(
    (ExitStarted event) async {
      print('OBS is exiting...');
      unawaited(obs.close());
      exit(0);
    },
  );

  // Get version info
  final version = await obs.general.getVersion();
  print('Connected to OBS v${version.obsVersion}');

  // Get stream status
  final status = await obs.stream.getStreamStatus();
  print('Streaming: ${status.outputActive}');

  // Keep running to receive events
  print('Listening for events... (Ctrl+C to exit)');
  await Future<void>.delayed(const Duration(hours: 1));
}
