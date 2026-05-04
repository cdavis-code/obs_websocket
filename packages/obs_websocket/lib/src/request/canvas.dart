import 'package:obs_websocket/obs_websocket.dart';

/// Canvas Requests
class Canvas {
  final ObsWebSocket obsWebSocket;

  Canvas(this.obsWebSocket);

  /// Gets an array of canvases in OBS.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.7.0
  Future<CanvasListResponse> getCanvasList() async {
    final response = await obsWebSocket.sendRequest(Request('GetCanvasList'));

    return CanvasListResponse.fromJson(response!.responseData!);
  }
}
