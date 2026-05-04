import 'package:obs_websocket/obs_websocket.dart';

/// Record Requests
class Record {
  final ObsWebSocket obsWebSocket;

  Record(this.obsWebSocket);

  /// Gets the status of the record output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<RecordStatusResponse> get status async => await getRecordStatus();

  /// Gets the status of the record output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<RecordStatusResponse> getStatus() async => await getRecordStatus();

  /// Gets the status of the record output.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<RecordStatusResponse> getRecordStatus() async {
    final response = await obsWebSocket.sendRequest(Request('GetRecordStatus'));

    return RecordStatusResponse.fromJson(response!.responseData!);
  }

  /// Toggles the status of the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> toggleRecord() async => await toggle();

  /// Toggles the status of the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> toggle() async =>
      await obsWebSocket.sendRequest(Request('ToggleRecord'));

  /// Starts the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> startRecord() async => await start();

  /// Starts the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> start() async =>
      await obsWebSocket.sendRequest(Request('StartRecord'));

  /// Stops the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> stopRecord() async => await stop();

  /// Stops the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<String> stop() async {
    final response = await obsWebSocket.sendRequest(Request('StopRecord'));

    return StringResponse.fromJson(response!.responseData!).value;
  }

  /// Toggles pause on the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0

  Future<void> toggleRecordPause() async => await togglePause();

  /// Toggles pause on the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> togglePause() async =>
      await obsWebSocket.sendRequest(Request('ToggleRecordPause'));

  /// Pauses the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> pauseRecord() async => await pause();

  /// Pauses the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> pause() async =>
      await obsWebSocket.sendRequest(Request('PauseRecord'));

  /// Resumes the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> resumeRecord() async => await resume();

  /// Resumes the record output.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> resume() async =>
      await obsWebSocket.sendRequest(Request('ResumeRecord'));
}
