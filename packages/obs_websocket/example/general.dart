import 'dart:async';
import 'dart:io';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Example demonstrating general OBS operations using .env file for credentials.
///
/// This example shows the new simplified approach using connectFromEnv().
/// For the old manual approach, see event.dart.

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

  await obs.subscribe(EventSubscription.all);

  obs.addHandler<SceneNameChanged>((SceneNameChanged sceneNameChanged) async {
    print('scene name changed: \n$sceneNameChanged');
  });

  obs.addHandler<SceneListChanged>((SceneListChanged sceneListChanged) async {
    print('scene list changed: \n$sceneListChanged');
  });

  obs.addHandler<InputVolumeChanged>(
      (InputVolumeChanged inputVolumeChanged) async {
    print('''input volume changed: \n
    inputVolumeMul - ${inputVolumeChanged.inputVolumeMul}
    inputVolumeDb - ${inputVolumeChanged.inputVolumeDb} 
    ''');
  });

  obs.addHandler<ExitStarted>((ExitStarted exitStarted) async {
    print('exit started: \n$exitStarted');

    unawaited(obs.close());

    exit(0);
  });

  final recordDirectoryResponse = await obs.config.getRecordDirectory();

  print(recordDirectoryResponse.recordDirectory);

  // final vol = await obs.inputs.getInputVolume(inputName: 'Media Source');

  // print(vol.inputVolumeMul);

  // final res = await obs.outputs.toggleReplayBuffer();

  // print(res);

  // final currentScene = await obs.scenes.getCurrentProgramScene();

  // get the id of the required sceneItem
  // final sceneItemId = await obs.sceneItems.getSceneItemId(
  //   sceneName: currentScene,
  //   sourceName: 'my face',
  // );

  // final indexId = await obs.sceneItems
  //     .getIndex(sceneName: currentScene, sceneItemId: sceneItemId);

  // print(indexId);

  // await obs.sceneItems.setIndex(
  //     sceneName: currentScene, sceneItemId: sceneItemId, sceneItemIndex: 4);

  // Use the raw send() method to call GetCanvasList
  print('\n=== Testing GetCanvasList with raw send() ===');
  final canvasListResponse = await obs.send('GetCanvasList');

  if (canvasListResponse != null && canvasListResponse.requestStatus.result) {
    print('GetCanvasList response:');
    print('Request Status: ${canvasListResponse.requestStatus.result}');
    print('Response Data: ${canvasListResponse.responseData}');
  } else {
    print('GetCanvasList request failed or returned no data');
  }

  final versionResponse = await obs.general.version;

  print(versionResponse.obsWebSocketVersion);

  var response = await obs.send('GetHotkeyList');

  // use a helper method to make a request
  final streamStatusResponse = await obs.stream.status;

  print('is streaming: ${streamStatusResponse.outputActive}');

  // the low-level method of making a request
  response = await obs.send('GetStreamStatus');

  print('request status: ${response?.requestStatus.result}');

  print('is streaming: ${response?.responseData?['outputActive']}');

  response = await obs.send('GetSceneList');

  // helper equivalent
  // final sceneListResponse = await obs.scenes.list();

  final scenes = response?.responseData?['scenes'] as List<dynamic>?;

  scenes?.forEach((dynamic scene) =>
      print('${scene['sceneName']} - ${scene['sceneIndex']}'));

  // helper equivalent...
  // for (var scene in sceneListResponse.scenes) {
  //   print('${scene.sceneName} - ${scene.sceneIndex}');
  // }

  final groups = await obs.scenes.getGroupList();

  for (final group in groups) {
    print(group);
  }

  // var sceneItems = await obs.sceneItems.getSceneItemList('Scene');

  // for (var sceneItem in sceneItems) {
  //   print('id: ${sceneItem.sceneItemId}, sourceName ${sceneItem.sourceName}');
  // }

  // var groupSceneItems = await obs.sceneItems.groupList('Group');

  // for (var groupSceneItem in groupSceneItems) {
  //   print(
  //       'id: ${groupSceneItem.sceneItemId}, sourceName ${groupSceneItem.sourceName}');
  // }

  final newSettings =
      Map<String, dynamic>.from(response?.responseData as Map<String, dynamic>);

  newSettings.addAll({
    'baseWidth': 1440,
    'baseHeight': 1080,
    'outputWidth': 1440,
    'outputHeight': 1080
  });

  response = await obs.send('SetVideoSettings', newSettings);

  print('$response');

  // await obs.scenes.setCurrentProgramScene('presentation');

  final statsResponse = await obs.general.stats;

  print('cpu usage: ${statsResponse.cpuUsage}');

  // final sourceScreenshotResponse =
  //     await obs.sources.screenshot(SourceScreenshot(
  //   sourceName: 'my face',
  //   imageFormat: 'jpeg',
  // ));

  // File('screen_shot.jpeg').writeAsBytesSync(sourceScreenshotResponse.bytes);
}
