import 'dart:io';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Example demonstrating audio monitoring using .env file for credentials.
void main(List<String> args) async {
  // Connect using .env file or environment variables
  final obs = await ObsWebSocket.connectFromEnv(
    logOptions: const LogOptions(LogLevel.debug),
    fallbackEventHandler: (Event event) =>
        print('Event: ${event.eventType} | Data: ${event.eventData}'),
  );

  if (obs == null) {
    print(
      'Error: No OBS connection configured.\n'
      'Set OBS_WEBSOCKET_URL environment variable or create a .env file.',
    );
    exit(1);
  }

  await obs
      .subscribe(EventSubscription.all | EventSubscription.inputVolumeMeters);

  obs.addHandler<InputVolumeChanged>(
      (InputVolumeChanged inputVolumeChanged) async =>
          print('''Input audio volume changed: 
      inputName - ${inputVolumeChanged.inputName}
      inputUuid - ${inputVolumeChanged.inputUuid}
      inputVolumeMul - ${inputVolumeChanged.inputVolumeMul}
      inputVolumeDb - ${inputVolumeChanged.inputVolumeDb}
    '''));

  obs.addHandler<InputVolumeMeters>(
      (InputVolumeMeters inputVolumeMeters) async => print(inputVolumeMeters));

  print('Listening for audio events... (Ctrl+C to exit)');
}
