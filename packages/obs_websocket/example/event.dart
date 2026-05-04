import 'dart:async';
import 'dart:io';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Example demonstrating advanced event handling using .env file for credentials.
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

  await obs
      .subscribe(EventSubscription.all | EventSubscription.inputVolumeMeters);

  obs.addHandler<SceneNameChanged>((SceneNameChanged sceneNameChanged) async =>
      print('Scene name changed: \n$sceneNameChanged'));

  obs.addHandler<SceneListChanged>((SceneListChanged sceneListChanged) async =>
      print('Scene list changed: \n$sceneListChanged'));

  obs.addHandler<InputAudioBalanceChanged>(
      (InputAudioBalanceChanged inputAudioBalanceChanged) async =>
          print('''Input audio balance changed: 
    inputAudioBalance - ${inputAudioBalanceChanged.inputAudioBalance}
    '''));

  obs.addHandler<InputVolumeMeters>(
      (InputVolumeMeters inputVolumeMeters) async => print(inputVolumeMeters));

  obs.addHandler<ExitStarted>((ExitStarted exitStarted) async {
    print('Exit started: \n$exitStarted');

    unawaited(obs.close());

    exit(0);
  });

  print('Listening for events... (Ctrl+C to exit)');
}
