import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Record Requests
class SceneItems {
  final ObsWebSocket obsWebSocket;

  SceneItems(this.obsWebSocket);

  /// Gets a list of all scene items in a scene.
  ///
  /// Scenes only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<SceneItemDetail>> getSceneItemList(String sceneName) async =>
      await list(sceneName);

  /// Gets a list of all scene items in a scene.
  ///
  /// Scenes only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<SceneItemDetail>> list(String sceneName) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetSceneItemList', requestData: {'sceneName': sceneName}),
    );

    final sceneItemListResponse = SceneItemListResponse.fromJson(
      response!.responseData!,
    );

    return sceneItemListResponse.sceneItems;
  }

  /// Basically GetSceneItemList, but for groups.
  ///
  /// Using groups at all in OBS is discouraged, as they are very broken under the hood.
  ///
  /// Groups only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<SceneItemDetail>> getGroupSceneItemList(String sceneName) async =>
      await groupList(sceneName);

  /// Basically GetSceneItemList, but for groups.
  ///
  /// Using groups at all in OBS is discouraged, as they are very broken under the hood.
  ///
  /// Groups only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<SceneItemDetail>> groupList(String sceneName) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetGroupSceneItemList', requestData: {'sceneName': sceneName}),
    );

    final sceneItemListResponse = SceneItemListResponse.fromJson(
      response!.responseData!,
    );

    return sceneItemListResponse.sceneItems;
  }

  /// Searches a scene for a source, and returns its id.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<int> getId({
    required String sceneName,
    required String sourceName,
    int? searchOffset,
  }) async => await getSceneItemId(
    sceneName: sceneName,
    sourceName: sourceName,
    searchOffset: searchOffset,
  );

  /// Searches a scene for a source, and returns its id.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<int> getSceneItemId({
    required String sceneName,
    required String sourceName,
    int? searchOffset,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemId',
        requestData: {
          'sceneName': sceneName,
          'sourceName': sourceName,
          'searchOffset': searchOffset,
        },
      ),
    );

    return IntegerResponse.fromJson(response!.responseData!).itemId;
  }

  /// Gets the enable state of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> getSceneItemEnabled({
    required String sceneName,
    required int sceneItemId,
  }) async => getEnabled(sceneName: sceneName, sceneItemId: sceneItemId);

  /// Gets the enable state of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> getEnabled({
    required String sceneName,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemEnabled',
        requestData: {'sceneName': sceneName, 'sceneItemId': sceneItemId},
      ),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Sets the enable state of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSceneItemEnabled(
    SceneItemEnableStateChanged sceneItemEnableStateChanged,
  ) async => setEnabled(sceneItemEnableStateChanged);

  /// Sets the enable state of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setEnabled(
    SceneItemEnableStateChanged sceneItemEnableStateChanged,
  ) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneItemEnabled',
      requestData: sceneItemEnableStateChanged.toJson(),
    ),
  );

  /// Gets the lock state of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// Complexity Rating: 3/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  Future<bool> getSceneItemLocked({
    required String sceneName,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemLocked',
        requestData: {'sceneName': sceneName, 'sceneItemId': sceneItemId},
      ),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Gets the lock state of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// Complexity Rating: 3/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  Future<bool> getLocked({
    required String sceneName,
    required int sceneItemId,
  }) async =>
      getSceneItemLocked(sceneName: sceneName, sceneItemId: sceneItemId);

  /// Sets the lock state of a scene item.
  ///
  /// Scenes and Group
  ///
  /// Complexity Rating: 3/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  Future<void> setSceneItemLocked({
    required String sceneName,
    required int sceneItemId,
    required bool sceneItemLocked,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneItemLocked',
      requestData: {
        'sceneName': sceneName,
        'sceneItemId': sceneItemId,
        'sceneItemLocked': sceneItemLocked,
      },
    ),
  );

  /// Sets the lock state of a scene item.
  ///
  /// Scenes and Group
  ///
  /// Complexity Rating: 3/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  Future<void> setLocked({
    required String sceneName,
    required int sceneItemId,
    required bool sceneItemLocked,
  }) async => setSceneItemLocked(
    sceneName: sceneName,
    sceneItemId: sceneItemId,
    sceneItemLocked: sceneItemLocked,
  );

  /// Gets the index position of a scene item in a scene.
  ///
  /// An index of 0 is at the bottom of the source list in the UI.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<int> getSceneItemIndex({
    required String sceneName,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemIndex',
        requestData: {'sceneName': sceneName, 'sceneItemId': sceneItemId},
      ),
    );

    return IntegerResponse.fromJson(response!.responseData!).itemId;
  }

  /// Gets the index position of a scene item in a scene.
  ///
  /// An index of 0 is at the bottom of the source list in the UI.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<int> getIndex({
    required String sceneName,
    required int sceneItemId,
  }) async => getSceneItemIndex(sceneName: sceneName, sceneItemId: sceneItemId);

  /// Sets the index position of a scene item in a scene.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSceneItemIndex({
    required String sceneName,
    required int sceneItemId,
    required int sceneItemIndex,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneItemIndex',
      requestData: {
        'sceneName': sceneName,
        'sceneItemId': sceneItemId,
        'sceneItemIndex': sceneItemIndex,
      },
    ),
  );

  /// Sets the index position of a scene item in a scene.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setIndex({
    required String sceneName,
    required int sceneItemId,
    required int sceneItemIndex,
  }) async => setSceneItemIndex(
    sceneName: sceneName,
    sceneItemId: sceneItemId,
    sceneItemIndex: sceneItemIndex,
  );

  /// Gets the transform (position, scale, rotation, crop) of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<Map<String, dynamic>> getSceneItemTransform({
    required String sceneName,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemTransform',
        requestData: {'sceneName': sceneName, 'sceneItemId': sceneItemId},
      ),
    );

    return response!.responseData!;
  }

  /// Sets the transform (position, scale, rotation, crop) of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSceneItemTransform({
    required String sceneName,
    required int sceneItemId,
    required Map<String, dynamic> sceneItemTransform,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneItemTransform',
      requestData: {
        'sceneName': sceneName,
        'sceneItemId': sceneItemId,
        'sceneItemTransform': sceneItemTransform,
      },
    ),
  );
}
