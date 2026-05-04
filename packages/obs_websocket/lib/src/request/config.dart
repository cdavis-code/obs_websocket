import 'package:obs_websocket/obs_websocket.dart';

/// Config Requests
class Config {
  final ObsWebSocket obsWebSocket;

  Config(this.obsWebSocket);

  /// Gets the value of a "slot" from the selected persistent data realm.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<Map<String, dynamic>> getPersistentData({
    required String realm,
    required String slotName,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetPersistentData',
        requestData: {'realm': realm, 'slotName': slotName},
      ),
    );

    return response!.responseData!;
  }

  /// Sets the value of a "slot" from the selected persistent data realm.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setPersistentData({
    required String realm,
    required String slotName,
    required dynamic slotValue,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetPersistentData',
      requestData: {
        'realm': realm,
        'slotName': slotName,
        'slotValue': slotValue,
      },
    ),
  );

  /// Gets an array of all scene collections
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SceneCollectionListResponse> getSceneCollectionList() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetSceneCollectionList'),
    );

    return SceneCollectionListResponse.fromJson(response!.responseData!);
  }

  /// Switches to a scene collection.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentSceneCollection(String sceneCollectionName) async =>
      await obsWebSocket.sendRequest(
        Request(
          'SetCurrentSceneCollection',
          requestData: {'sceneCollectionName': sceneCollectionName},
        ),
      );

  /// Creates a new scene collection, switching to it in the process.
  ///
  /// Note: This will block until the collection has finished changing.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> createSceneCollection(String sceneCollectionName) async =>
      await obsWebSocket.sendRequest(
        Request(
          'CreateSceneCollection',
          requestData: {'sceneCollectionName': sceneCollectionName},
        ),
      );

  /// Gets an array of all profiles
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<ProfileListResponse> getProfileList() async {
    final response = await obsWebSocket.sendRequest(Request('GetProfileList'));

    return ProfileListResponse.fromJson(response!.responseData!);
  }

  /// Switches to a profile.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentProfile(String profileName) async =>
      await obsWebSocket.sendRequest(
        Request('SetCurrentProfile', requestData: {'profileName': profileName}),
      );

  /// Creates a new profile, switching to it in the process
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> createProfile(String profileName) async =>
      await obsWebSocket.sendRequest(
        Request('CreateProfile', requestData: {'profileName': profileName}),
      );

  /// Removes a profile. If the current profile is chosen, it will change to a different profile first.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> removeProfile(String profileName) async =>
      await obsWebSocket.sendRequest(
        Request('RemoveProfile', requestData: {'profileName': profileName}),
      );

  /// Gets a parameter from the current profile's configuration.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<ProfileParameterResponse> getProfileParameter({
    required String parameterCategory,
    required String parameterName,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetProfileParameter',
        requestData: {
          'parameterCategory': parameterCategory,
          'parameterName': parameterName,
        },
      ),
    );

    return ProfileParameterResponse.fromJson(response!.responseData!);
  }

  /// Sets the value of a parameter in the current profile's configuration.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setProfileParameter({
    required String parameterCategory,
    required String parameterName,
    required String parameterValue,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetProfileParameter',
      requestData: {
        'parameterCategory': parameterCategory,
        'parameterName': parameterName,
        'parameterValue': parameterValue,
      },
    ),
  );

  /// Gets the current video settings.
  ///
  /// Note: To get the true FPS value, divide the FPS numerator by the FPS denominator. Example: 60000/1001
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<VideoSettingsResponse> getVideoSettings() async => videoSettings();

  /// Gets the current video settings.
  ///
  /// Note: To get the true FPS value, divide the FPS numerator by the FPS denominator. Example: 60000/1001
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<VideoSettingsResponse> videoSettings() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetVideoSettings'),
    );

    return VideoSettingsResponse.fromJson(response!.responseData!);
  }

  /// Sets the current video settings.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setVideoSettings(VideoSettings videoSettings) async =>
      await obsWebSocket.sendRequest(
        Request('SetVideoSettings', requestData: videoSettings.toJson()),
      );

  /// Gets the current stream service settings (stream destination).
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StreamServiceSettingsResponse> getStreamServiceSettings() async =>
      await streamServiceSettings();

  /// Gets the current stream service settings (stream destination).
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StreamServiceSettingsResponse> streamServiceSettings() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetStreamServiceSettings'),
    );

    return StreamServiceSettingsResponse.fromJson(response!.responseData!);
  }

  /// Sets the current stream service settings (stream destination).
  ///
  /// Note: Simple RTMP settings can be set with type rtmp_custom and the settings fields server and key.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setStreamServiceSettings({
    required String streamServiceType,
    required Map<String, dynamic> streamServiceSettings,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetStreamServiceSettings',
      requestData: {
        'streamServiceType': streamServiceType,
        'streamServiceSettings': streamServiceSettings,
      },
    ),
  );

  /// Gets the current directory that the record output is set to.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<RecordDirectoryResponse> getRecordDirectory() async =>
      await recordDirectory();

  /// Gets the current directory that the record output is set to.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<RecordDirectoryResponse> recordDirectory() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetRecordDirectory'),
    );

    return RecordDirectoryResponse.fromJson(response!.responseData!);
  }
}
