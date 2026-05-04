import 'dart:async';
import 'dart:io';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Example demonstrating scene item automation using .env file for credentials.
void main(List<String> args) async {
  Loggy.initLoggy();

  // Connect using .env file or environment variables
  final obsWebSocket = await ObsWebSocket.connectFromEnv(
    logOptions: const LogOptions(LogLevel.debug),
    fallbackEventHandler: (Event event) =>
        print('Event: ${event.eventType} | Data: ${event.eventData}'),
  );

  if (obsWebSocket == null) {
    print(
      'Error: No OBS connection configured.\n'
      'Set OBS_WEBSOCKET_URL environment variable or create a .env file.',
    );
    exit(1);
  }

  // tell obsWebSocket to listen to events, since the default is to ignore them
  await obsWebSocket.subscribe(EventSubscription.all);

  // Scene item to show/hide
  final sceneItem = 'my face';

  // get the current scene
  final currentScene = await obsWebSocket.scenes.getCurrentProgramScene();

  // get the id of the required sceneItem
  final sceneItemId = await obsWebSocket.sceneItems.getSceneItemId(
    sceneName: currentScene,
    sourceName: sceneItem,
  );

  // this handler will only run when a SceneItemEnableStateChanged event is generated
  obsWebSocket.addHandler<SceneItemEnableStateChanged>(
      (SceneItemEnableStateChanged sceneItemEnableStateChanged) async {
    print(
        'event: ${sceneItemEnableStateChanged.sceneName} ${sceneItemEnableStateChanged.sceneItemEnabled}');

    // make sure we have the correct sceneItem and that it's currently visible
    if (sceneItemEnableStateChanged.sceneName == currentScene &&
        sceneItemEnableStateChanged.sceneItemEnabled) {
      // wait 13 seconds
      await Future<void>.delayed(const Duration(seconds: 13));

      // hide the sceneItem
      await obsWebSocket.sceneItems.setSceneItemEnabled(
          SceneItemEnableStateChanged(
              sceneName: currentScene,
              sceneItemId: sceneItemId,
              sceneItemEnabled: false));

      // close the socket when complete
      await obsWebSocket.close();
    }
  });

// get the current state of the sceneItem
  final sceneItemEnabled = await obsWebSocket.sceneItems.getSceneItemEnabled(
    sceneName: currentScene,
    sceneItemId: sceneItemId,
  );

// if the sceneItem is hidden, show it
  if (!sceneItemEnabled) {
    await obsWebSocket.sceneItems.setSceneItemEnabled(
        SceneItemEnableStateChanged(
            sceneName: currentScene,
            sceneItemId: sceneItemId,
            sceneItemEnabled: true));
  }
}
