import 'package:obs_websocket/obs_websocket.dart';

/// Outputs Requests
class Outputs {
  final ObsWebSocket obsWebSocket;

  Outputs(this.obsWebSocket);

  /// Gets the status of the virtualcam output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> getVirtualCamStatus() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetVirtualCamStatus'),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Toggles the state of the virtualcam output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggleVirtualCam() async {
    final response = await obsWebSocket.sendRequest(
      Request('ToggleVirtualCam'),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Starts the virtualcam output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> startVirtualCam() async =>
      await obsWebSocket.sendRequest(Request('StartVirtualCam'));

  /// Stops the virtualcam output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> stopVirtualCam() async =>
      await obsWebSocket.sendRequest(Request('StopVirtualCam'));

  /// Gets the status of the replay buffer output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> getReplayBufferStatus() async {
    final response = await obsWebSocket.sendRequest(
      Request('GetReplayBufferStatus'),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Toggles the state of the replay buffer output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggleReplayBuffer() async {
    final response = await obsWebSocket.sendRequest(
      Request('ToggleReplayBuffer'),
    );

    if (response?.requestStatus.code != 100) {
      throw Exception('${response?.requestStatus.comment}');
    }

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Starts the replay buffer output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> startReplayBuffer(String outputName) async =>
      await obsWebSocket.sendRequest(Request('StartReplayBuffer'));

  /// Stops the replay buffer output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> stopReplayBuffer(String outputName) async =>
      await obsWebSocket.sendRequest(Request('StopReplayBuffer'));

  /// Saves the contents of the replay buffer output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> saveReplayBuffer(String outputName) async =>
      await obsWebSocket.sendRequest(Request('SaveReplayBuffer'));

  /// Toggles the status of an output.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggle(String outputName) async =>
      await toggleOutput(outputName);

  /// Toggles the status of an output.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggleOutput(String outputName) async {
    final response = await obsWebSocket.sendRequest(Request('ToggleOutput'));

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Starts an output.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> startOutput(String outputName) async => await start(outputName);

  /// Starts an output.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> start(String outputName) async =>
      await obsWebSocket.sendRequest(Request('StartOutput'));

  /// Stops an output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> stopOutput(String outputName) async => await stop(outputName);

  /// Stops an output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> stop(String outputName) async =>
      await obsWebSocket.sendRequest(Request('StopOutput'));
}
