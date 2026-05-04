import 'package:obs_websocket/obs_websocket.dart';

/// Sources Requests
class Sources {
  final ObsWebSocket obsWebSocket;

  Sources(this.obsWebSocket);

  /// Gets the active and show state of a source.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SourceActiveResponse> getSourceActive(String sourceName) async =>
      await active(sourceName);

  /// Gets the active and show state of a source.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SourceActiveResponse> active(String sourceName) async {
    final response = await obsWebSocket.sendRequest(Request('GetSourceActive'));

    return SourceActiveResponse.fromJson(response!.responseData!);
  }

  /// Gets a Base64-encoded screenshot of a source.
  ///
  /// The imageWidth and imageHeight parameters are treated as "scale to inner", meaning the smallest ratio will be used and the aspect ratio of the original resolution is kept. If imageWidth and imageHeight are not specified, the compressed image will use the full resolution of the source.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SourceScreenshotResponse> getSourceScreenshot(
    SourceScreenshot sourceScreenshot,
  ) async => await screenshot(sourceScreenshot);

  /// Gets a Base64-encoded screenshot of a source.
  ///
  /// The imageWidth and imageHeight parameters are treated as "scale to inner", meaning the smallest ratio will be used and the aspect ratio of the original resolution is kept. If imageWidth and imageHeight are not specified, the compressed image will use the full resolution of the source.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SourceScreenshotResponse> screenshot(
    SourceScreenshot sourceScreenshot,
  ) async {
    final response = await obsWebSocket.sendRequest(
      Request('GetSourceScreenshot', requestData: sourceScreenshot.toJson()),
    );

    return SourceScreenshotResponse.fromJson(response!.responseData!);
  }

  /// Saves a screenshot of a source to the filesystem.
  ///
  /// The imageWidth and imageHeight parameters are treated as "scale to inner", meaning the smallest ratio will be used and the aspect ratio of the original resolution is kept. If imageWidth and imageHeight are not specified, the compressed image will use the full resolution of the source.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SourceScreenshotResponse> saveSourceScreenshot(
    SourceScreenshot sourceScreenshot,
  ) async => await saveScreenshot(sourceScreenshot);

  /// Saves a screenshot of a source to the filesystem.
  ///
  /// The imageWidth and imageHeight parameters are treated as "scale to inner", meaning the smallest ratio will be used and the aspect ratio of the original resolution is kept. If imageWidth and imageHeight are not specified, the compressed image will use the full resolution of the source.
  ///
  /// Compatible with inputs and scenes.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<SourceScreenshotResponse> saveScreenshot(
    SourceScreenshot sourceScreenshot,
  ) async {
    final response = await obsWebSocket.sendRequest(
      Request('SaveSourceScreenshot', requestData: sourceScreenshot.toJson()),
    );

    return SourceScreenshotResponse.fromJson(response!.responseData!);
  }
}
