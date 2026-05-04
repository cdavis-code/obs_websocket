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
}
