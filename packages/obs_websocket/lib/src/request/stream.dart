import 'package:obs_websocket/obs_websocket.dart';

/// Stream Requests
class Stream {
  final ObsWebSocket obsWebSocket;

  Stream(this.obsWebSocket);

  /// Gets the status of the stream output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StreamStatusResponse> get status async => await getStreamStatus();

  /// Gets the status of the stream output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StreamStatusResponse> get getStatus async => await getStreamStatus();

  /// Gets the status of the stream output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StreamStatusResponse> getStreamStatus() async {
    final response = await obsWebSocket.sendRequest(Request('GetStreamStatus'));

    return StreamStatusResponse.fromJson(response!.responseData!);
  }

  /// Toggles the status of the stream output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggleStream() async => await toggle();

  /// Toggles the status of the stream output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<bool> toggle() async {
    final response = await obsWebSocket.sendRequest(
      Request('ToggleStream', expectResponse: true),
    );

    return BooleanResponse.fromJson(response!.responseData!).enabled;
  }

  /// Starts the stream output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> startStream() async => await start();

  /// Starts the stream output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> start() async =>
      await obsWebSocket.sendRequest(Request('StartStream'));

  /// Stops the stream output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> stopStream() async => await stop();

  /// Stops the stream output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> stop() async =>
      await obsWebSocket.sendRequest(Request('StopStream'));

  /// Sends CEA-608 caption text over the stream output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> sendStreamCaption(String captionText) async =>
      await obsWebSocket.sendRequest(
        Request('SendStreamCaption', requestData: {'captionText': captionText}),
      );
}
