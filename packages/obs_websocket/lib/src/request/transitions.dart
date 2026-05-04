import 'package:obs_websocket/obs_websocket.dart';

/// Transitions Requests
class Transitions {
  final ObsWebSocket obsWebSocket;

  Transitions(this.obsWebSocket);

  /// Sets the current scene transition.
  ///
  /// Small note: While the namespace of scene transitions is generally unique, that uniqueness is not a guarantee as it is with other resources like inputs.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentScene(String transitionName) async =>
      setCurrentSceneTransition(transitionName);

  /// Sets the current scene transition.
  ///
  /// Small note: While the namespace of scene transitions is generally unique, that uniqueness is not a guarantee as it is with other resources like inputs.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentSceneTransition(String transitionName) async =>
      await obsWebSocket.sendRequest(
        Request(
          'SetCurrentSceneTransition',
          requestData: {'transitionName': transitionName},
        ),
      );

  /// Sets the duration of the current scene transition, if it is not fixed.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  ///
  /// [transitionDuration] in milliseconds, >= 50, <= 20000
  Future<void> setCurrentSceneDuration(int transitionDuration) async =>
      await setCurrentSceneTransitionDuration(transitionDuration);

  /// Sets the duration of the current scene transition, if it is not fixed.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  ///
  /// [transitionDuration] in milliseconds, >= 50, <= 20000
  Future<void> setCurrentSceneTransitionDuration(
    int transitionDuration,
  ) async => await obsWebSocket.sendRequest(
    Request(
      'SetCurrentSceneTransitionDuration',
      requestData: {'transitionDuration': transitionDuration},
    ),
  );

  /// Triggers the current scene transition. Same functionality as the Transition button in studio mode.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> triggerStudioMode() async => await triggerStudioModeTransition();

  /// Triggers the current scene transition. Same functionality as the Transition button in studio mode.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> triggerStudioModeTransition() async =>
      await obsWebSocket.sendRequest(Request('TriggerStudioModeTransition'));

  /// Gets an array of all available transition kinds.
  ///
  /// Similar to `GetInputKindList`.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<String>> getTransitionKindList() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetTransitionKindList'),
    );

    return (response!.responseData!['transitionKinds'] as List).cast<String>();
  }

  /// Gets an array of all scene transitions in OBS.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<Map<String, dynamic>> getSceneTransitionList() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetSceneTransitionList'),
    );

    return response!.responseData!;
  }

  /// Gets information about the current scene transition.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<Map<String, dynamic>> getCurrentSceneTransition() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetCurrentSceneTransition'),
    );

    return response!.responseData!;
  }

  /// Sets the settings of the current scene transition.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setCurrentSceneTransitionSettings({
    required Map<String, dynamic> transitionSettings,
    bool? overlay,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetCurrentSceneTransitionSettings',
      requestData: {
        'transitionSettings': transitionSettings,
        'overlay': ?overlay,
      },
    ),
  );

  /// Gets the cursor position of the current scene transition.
  ///
  /// Note: `transitionCursor` will return 1.0 when the transition is inactive.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<double> getCurrentSceneTransitionCursor() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetCurrentSceneTransitionCursor'),
    );

    return (response!.responseData!['transitionCursor'] as num).toDouble();
  }

  /// Sets the position of the T-Bar (Transition bar).
  ///
  /// Note: Only Studio Mode is supported. Studio Mode must be enabled.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  ///
  /// [position] >= 0.0, <= 1.0
  Future<void> setTBarPosition({
    required double position,
    bool? release,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetTBarPosition',
      requestData: {'position': position, 'release': ?release},
    ),
  );
}
