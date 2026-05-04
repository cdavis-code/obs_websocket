import 'package:obs_websocket/obs_websocket.dart';

/// Scenes Requests
class Scenes {
  final ObsWebSocket obsWebSocket;

  Scenes(this.obsWebSocket);

  /// Gets an array of all scenes in OBS.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SceneListResponse> getSceneList() async => await list();

  /// Gets an array of all scenes in OBS.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SceneListResponse> getList() async => await list();

  /// Gets an array of all scenes in OBS.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SceneListResponse> list() async {
    final response = await obsWebSocket.sendRequest(Request('GetSceneList'));

    return SceneListResponse.fromJson(response!.responseData!);
  }

  ///Gets an array of all groups in OBS.
  ///
  ///Groups in OBS are actually scenes, but renamed and modified. In obs-websocket, we treat them as scenes where we can.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<String>> getGroupList() async => await groupList();

  ///Gets an array of all groups in OBS.
  ///
  ///Groups in OBS are actually scenes, but renamed and modified. In obs-websocket, we treat them as scenes where we can.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<String>> groupList() async {
    final response = await obsWebSocket.sendRequest(Request('GetGroupList'));

    return StringListResponse.fromJson(response!.responseData!).items;
  }

  /// Gets the current program scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> getCurrentProgramScene() async => await getCurrentProgram();

  /// Gets the current program scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> getCurrentProgram() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetCurrentProgramScene'),
    );

    return StringResponse.fromJson(response!.responseData!).value;
  }

  /// Sets the current program scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentProgramScene(String sceneName) async =>
      await setCurrentProgram(sceneName);

  /// Sets the current program scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentProgram(String sceneName) async =>
      await obsWebSocket.sendRequest(
        Request(
          'SetCurrentProgramScene',
          requestData: {'sceneName': sceneName},
        ),
      );

  /// Gets the current preview scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> getCurrentPreviewScene() async => await getCurrentPreview();

  /// Gets the current preview scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> getCurrentPreview() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetCurrentPreviewScene'),
    );

    return StringResponse.fromJson(response!.responseData!).value;
  }

  /// Sets the current preview scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentPreviewScene(String sceneName) async =>
      setCurrentPreview(sceneName);

  /// Sets the current preview scene.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentPreview(String sceneName) async =>
      await obsWebSocket.sendRequest(
        Request(
          'SetCurrentPreviewScene',
          requestData: {'sceneName': sceneName},
        ),
      );

  /// Creates a new scene in OBS.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> createScene(String sceneName) async => await create(sceneName);

  /// Creates a new scene in OBS.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> create(String sceneName) async => await obsWebSocket.sendRequest(
    Request('CreateScene', requestData: {'sceneName': sceneName}),
  );

  /// Removes a scene from OBS.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> removeScene(String sceneName) async => await remove(sceneName);

  /// Removes a scene from OBS.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> remove(String sceneName) async => await obsWebSocket.sendRequest(
    Request('RemoveScene', requestData: {'sceneName': sceneName}),
  );

  /// Sets the name of a scene (rename).
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSceneName(String sceneName) async => await set(sceneName);

  /// Sets the name of a scene (rename).
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> set(String sceneName) async => await obsWebSocket.sendRequest(
    Request('SetSceneName', requestData: {'sceneName': sceneName}),
  );

  /// Gets the scene transition overridden for a scene.
  ///
  /// Complexity Rating: 2/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  Future<SceneSceneTransitionOverrideResponse> getSceneSceneTransitionOverride(
    String sceneName,
  ) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneSceneTransitionOverride',
        requestData: {'sceneName': sceneName},
      ),
    );

    return SceneSceneTransitionOverrideResponse.fromJson(
      response!.responseData!,
    );
  }

  /// Sets the scene transition overridden for a scene.
  ///
  /// Complexity Rating: 2/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  Future<void> setSceneSceneTransitionOverride(
    String sceneName, {
    String? transitionName,
    int? transitionDuration,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneSceneTransitionOverride',
      requestData: {
        'sceneName': sceneName,
        'transitionName': transitionName,
        'transitionDuration': transitionDuration,
      },
    ),
  );
}
