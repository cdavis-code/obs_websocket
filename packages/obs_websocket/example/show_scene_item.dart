import 'package:loggy/loggy.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:universal_io/io.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) async {
  Loggy.initLoggy();

  final config = loadYaml(File('config.yaml').readAsStringSync());

  final sceneItem = 'my face';

  final obsWebSocket = await ObsWebSocket.connect(
    config['host'],
    password: config['password'],
  );

  // tell obsWebSocket to listen to events, since the default is to ignore them
  await obsWebSocket.subscribe(EventSubscription.all);

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
