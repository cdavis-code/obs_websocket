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
  ///
  /// The [sceneItemTransform] map is validated against
  /// [SceneItemTransform.knownKeys]; unknown keys throw
  /// [ObsArgumentException] so typos surface client-side instead of being
  /// silently dropped by OBS. Pass [validateKeys] = `false` to opt out
  /// (e.g. when sending future protocol fields not yet recognised by
  /// this package).
  Future<void> setSceneItemTransform({
    required String sceneName,
    required int sceneItemId,
    required Map<String, dynamic> sceneItemTransform,
    bool validateKeys = true,
  }) async {
    if (validateKeys) {
      SceneItemTransform.validate(sceneItemTransform);
    }
    await obsWebSocket.sendRequest(
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

  /// Strongly-typed companion to [setSceneItemTransform]. Only the
  /// non-null fields of [transform] are forwarded to OBS.
  Future<void> setSceneItemTransformTyped({
    required String sceneName,
    required int sceneItemId,
    required SceneItemTransform transform,
  }) async => setSceneItemTransform(
    sceneName: sceneName,
    sceneItemId: sceneItemId,
    sceneItemTransform: transform.toJson(),
    validateKeys: false,
  );

  /// Strongly-typed companion to [getSceneItemTransform]. Returns the
  /// transform parsed into a [SceneItemTransform].
  Future<SceneItemTransform> getSceneItemTransformTyped({
    required String sceneName,
    required int sceneItemId,
  }) async {
    final raw = await getSceneItemTransform(
      sceneName: sceneName,
      sceneItemId: sceneItemId,
    );
    final nested = raw['sceneItemTransform'];
    if (nested is Map<String, dynamic>) {
      return SceneItemTransform.fromJson(nested);
    }
    return SceneItemTransform.fromJson(raw);
  }

  /// Creates a new scene item using a source.
  ///
  /// Scenes only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<int> createSceneItem({
    required String sceneName,
    required String sourceName,
    bool? sceneItemEnabled,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'CreateSceneItem',
        requestData: {
          'sceneName': sceneName,
          'sourceName': sourceName,
          'sceneItemEnabled': ?sceneItemEnabled,
        },
      ),
    );

    return IntegerResponse.fromJson(response!.responseData!).itemId;
  }

  /// Removes a scene item from a scene.
  ///
  /// Scenes only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> removeSceneItem({
    required String sceneName,
    required int sceneItemId,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'RemoveSceneItem',
      requestData: {'sceneName': sceneName, 'sceneItemId': sceneItemId},
    ),
  );

  /// Duplicates a scene item, copying all transform and crop info.
  ///
  /// Scenes only
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<int> duplicateSceneItem({
    required String sceneName,
    required int sceneItemId,
    String? destinationSceneName,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'DuplicateSceneItem',
        requestData: {
          'sceneName': sceneName,
          'sceneItemId': sceneItemId,
          'destinationSceneName': ?destinationSceneName,
        },
      ),
    );

    return IntegerResponse.fromJson(response!.responseData!).itemId;
  }

  /// Gets the blend mode of a scene item.
  ///
  /// Blend modes: normal, additive, subtract, screen, multiply, lighten,
  /// darken.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> getSceneItemBlendMode({
    required String sceneName,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemBlendMode',
        requestData: {'sceneName': sceneName, 'sceneItemId': sceneItemId},
      ),
    );

    return response!.responseData!['sceneItemBlendMode'] as String;
  }

  /// Sets the blend mode of a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSceneItemBlendMode({
    required String sceneName,
    required int sceneItemId,
    required String sceneItemBlendMode,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneItemBlendMode',
      requestData: {
        'sceneName': sceneName,
        'sceneItemId': sceneItemId,
        'sceneItemBlendMode': sceneItemBlendMode,
      },
    ),
  );

  /// Gets the source associated with a scene item.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.4.0
  Future<Map<String, dynamic>> getSceneItemSource({
    String? sceneName,
    String? sceneUuid,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemSource',
        requestData: {
          'sceneName': ?sceneName,
          'sceneUuid': ?sceneUuid,
          'sceneItemId': sceneItemId,
        },
      ),
    );

    return response!.responseData!;
  }

  /// Gets the private settings of a scene item.
  ///
  /// Note: This request is mainly used internally by OBS.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.6.0
  Future<Map<String, dynamic>> getSceneItemPrivateSettings({
    String? sceneName,
    String? sceneUuid,
    required int sceneItemId,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetSceneItemPrivateSettings',
        requestData: {
          'sceneName': ?sceneName,
          'sceneUuid': ?sceneUuid,
          'sceneItemId': sceneItemId,
        },
      ),
    );

    return response!.responseData!;
  }

  /// Sets the private settings of a scene item.
  ///
  /// Note: This request is mainly used internally by OBS.
  ///
  /// Scenes and Groups
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.6.0
  Future<void> setSceneItemPrivateSettings({
    String? sceneName,
    String? sceneUuid,
    required int sceneItemId,
    required Map<String, dynamic> sceneItemSettings,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSceneItemPrivateSettings',
      requestData: {
        'sceneName': ?sceneName,
        'sceneUuid': ?sceneUuid,
        'sceneItemId': sceneItemId,
        'sceneItemSettings': sceneItemSettings,
      },
    ),
  );
}
