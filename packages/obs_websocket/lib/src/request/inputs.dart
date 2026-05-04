import 'package:obs_websocket/obs_websocket.dart';

/// Inputs Requests
class Inputs {
  final ObsWebSocket obsWebSocket;

  Inputs(this.obsWebSocket);

  /// Gets an array of all inputs in OBS.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<Input>> getInputList(String? inputKind) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetInputList', requestData: {'inputKind': inputKind}),
    );

    if (response == null || response.responseData == null) return <Input>[];

    return InputKindResponse.fromJson(response.responseData!).inputs;
  }

  /// Gets an array of all available input kinds in OBS.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<String>> getInputKindList([bool unversioned = false]) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetInputKindList', requestData: {'unversioned': unversioned}),
    );

    if (response == null || response.responseData == null) return [];

    return StringListResponse.fromJson(response.responseData!).inputKinds ?? [];
  }

  /// Gets the names of all special inputs.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SpecialInputsResponse> specialInputs() async => getSpecialInputs();

  /// Gets the names of all special inputs.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SpecialInputsResponse> getSpecialInputs() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetSpecialInputs'),
    );

    return SpecialInputsResponse.fromJson(response!.responseData!);
  }

  /// Creates a new input, adding it as a scene item to the specified scene.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<CreateInputResponse> create({
    String? sceneName,
    String? sceneUuid,
    required String inputName,
    required String inputKind,
    dynamic inputSettings,
    bool? sceneItemEnabled,
  }) async => createInput(
    sceneName: sceneName,
    sceneUuid: sceneUuid,
    inputName: inputName,
    inputKind: inputKind,
    inputSettings: inputSettings,
    sceneItemEnabled: sceneItemEnabled,
  );

  /// Creates a new input, adding it as a scene item to the specified scene.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<CreateInputResponse> createInput({
    String? sceneName,
    String? sceneUuid,
    required String inputName,
    required String inputKind,
    Map<String, dynamic>? inputSettings,
    bool? sceneItemEnabled,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'CreateInput',
        requestData: {
          'sceneName': sceneName,
          'sceneUuid': sceneUuid,
          'inputName': inputName,
          'inputKind': inputKind,
          'inputSettings': inputSettings,
          'sceneItemEnabled': sceneItemEnabled,
        },
      ),
    );

    return CreateInputResponse.fromJson(response!.responseData!);
  }

  /// Removes an existing input.
  ///
  /// Note: Will immediately remove all associated scene items.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> removeInput({String? inputName, String? inputUuid}) async =>
      await remove(inputName: inputName, inputUuid: inputUuid);

  /// Removes an existing input.
  ///
  /// Note: Will immediately remove all associated scene items.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> remove({String? inputName, String? inputUuid}) async {
    if (inputName == null && inputUuid == null) {
      throw ArgumentError('inputName or inputUuid must be provided');
    }

    await obsWebSocket.sendRequest(
      Request(
        'RemoveInput',
        requestData: {'inputName': inputName, 'inputUuid': inputUuid},
      ),
    );
  }

  /// Sets the name of an input (rename).
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setInputName({
    String? inputName,
    String? inputUuid,
    required String newInputName,
  }) async => await setName(
    inputName: inputName,
    inputUuid: inputUuid,
    newInputName: newInputName,
  );

  /// Sets the name of an input (rename).
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setName({
    String? inputName,
    String? inputUuid,
    required String newInputName,
  }) async {
    await obsWebSocket.sendRequest(
      Request(
        'SetInputName',
        requestData: {
          'inputName': inputName,
          'inputUuid': inputUuid,
          'newInputName': newInputName,
        },
      ),
    );
  }

  /// Gets the default settings for an input kind.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<InputDefaultSettingsResponse> getInputDefaultSettings({
    required String inputKind,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetInputDefaultSettings', requestData: {'inputKind': inputKind}),
    );

    return InputDefaultSettingsResponse.fromJson(response!.responseData!);
  }

  /// Gets the default settings for an input kind.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<InputDefaultSettingsResponse> defaultSettings({
    required String inputKind,
  }) async => getInputDefaultSettings(inputKind: inputKind);

  /// Gets the settings of an input.
  ///
  /// Note: Does not include defaults. To create the entire settings object, overlay inputSettings over the defaultInputSettings provided by GetInputDefaultSettings.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<InputSettingsResponse> getInputSettings({
    String? inputName,
    String? inputUuid,
  }) async {
    if (inputName == null && inputUuid == null) {
      throw ArgumentError('inputName or inputUuid must be provided');
    }

    final response = await obsWebSocket.sendRequest(
      Request(
        'GetInputSettings',
        requestData: {'inputName': inputName, 'inputUuid': inputUuid},
      ),
    );

    return InputSettingsResponse.fromJson(response!.responseData!);
  }

  /// Gets the settings of an input.
  ///
  /// Note: Does not include defaults. To create the entire settings object, overlay inputSettings over the defaultInputSettings provided by GetInputDefaultSettings.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<InputSettingsResponse> settings({
    String? inputName,
    String? inputUuid,
  }) async => getInputSettings(inputName: inputName, inputUuid: inputUuid);

  /// Sets the settings of an input.
  ///
  /// Note: Does not include defaults. To create the entire settings object, overlay inputSettings over the defaultInputSettings provided by GetInputDefaultSettings.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setInputSettings({
    String? inputName,
    String? inputUuid,
    required Map<String, dynamic> inputSettings,
    bool? overlay,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetInputSettings',
      requestData: {
        'inputName': inputName,
        'inputUuid': inputUuid,
        'inputSettings': inputSettings,
        'overlay': overlay,
      },
    ),
  );

  /// Sets the settings of an input.
  ///
  /// Note: Does not include defaults. To create the entire settings object, overlay inputSettings over the defaultInputSettings provided by GetInputDefaultSettings.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSettings({
    String? inputName,
    String? inputUuid,
    required Map<String, dynamic> inputSettings,
    bool? overlay,
  }) async => setInputSettings(
    inputName: inputName,
    inputUuid: inputUuid,
    inputSettings: inputSettings,
    overlay: overlay,
  );

  /// Gets the audio mute state of an input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> getMute(String inputName) async => getInputMute(inputName);

  /// Gets the audio mute state of an input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> getInputMute(String inputName) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetInputMute', requestData: {'inputName': inputName}),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Sets the audio mute state of an input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setInputMute({
    String? inputName,
    String? inputUuid,
    required bool inputMuted,
  }) async {
    if (inputName == null && inputUuid == null) {
      throw ArgumentError('inputName or inputUuid must be provided');
    }

    await obsWebSocket.sendRequest(
      Request(
        'SetInputMute',
        requestData: {
          'inputName': inputName,
          'inputUuid': inputUuid,
          'inputMuted': inputMuted,
        },
      ),
    );
  }

  /// Sets the audio mute state of an input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setMute({
    String? inputName,
    String? inputUuid,
    required bool inputMuted,
  }) async => setInputMute(
    inputMuted: inputMuted,
    inputName: inputName,
    inputUuid: inputUuid,
  );

  /// Toggles the audio mute state of an input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggleMute({String? inputName, String? inputUuid}) async =>
      toggleInputMute(inputName: inputName, inputUuid: inputUuid);

  /// Toggles the audio mute state of an input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggleInputMute({String? inputName, String? inputUuid}) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'ToggleInputMute',
        requestData: {'inputName': inputName, 'inputUuid': inputUuid},
      ),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Gets the current volume setting of an input.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<InputVolumeResponse> getInputVolume({
    String? inputName,
    String? inputUuid,
  }) async {
    if (inputName == null && inputUuid == null) {
      throw ArgumentError('inputName or inputUuid must be provided');
    }

    final response = await obsWebSocket.sendRequest(
      Request(
        'GetInputVolume',
        requestData: {'inputName': inputName, 'inputUuid': inputUuid},
      ),
    );

    return InputVolumeResponse.fromJson(response!.responseData!);
  }
}
