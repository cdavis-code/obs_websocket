import 'package:obs_websocket/obs_websocket.dart';

/// Filters Requests
class Filters {
  final ObsWebSocket obsWebSocket;

  Filters(this.obsWebSocket);

  /// Removes a filter from a source.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> removeSource({
    required String sourceName,
    required String filterName,
  }) async =>
      await removeSourceFilter(sourceName: sourceName, filterName: filterName);

  /// Removes a filter from a source.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> removeSourceFilter({
    required String sourceName,
    required String filterName,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'RemoveSourceFilter',
      requestData: {'sourceName': sourceName, 'filterName': filterName},
    ),
  );

  /// Sets the name of a source filter (rename).
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSourceName({
    required String sourceName,
    required String filterName,
    required String newFilterName,
  }) async => await setSourceFilterName(
    sourceName: sourceName,
    filterName: filterName,
    newFilterName: newFilterName,
  );

  /// Sets the name of a source filter (rename).
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSourceFilterName({
    required String sourceName,
    required String filterName,
    required String newFilterName,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSourceFilterName',
      requestData: {
        'sourceName': sourceName,
        'filterName': filterName,
        'newFilterName': newFilterName,
      },
    ),
  );

  /// Sets the index position of a filter on a source.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSourceIndex({
    required String sourceName,
    required String filterName,
    required int filterIndex,
  }) async => await setSourceFilterIndex(
    sourceName: sourceName,
    filterName: filterName,
    filterIndex: filterIndex,
  );

  /// Sets the index position of a filter on a source.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSourceFilterIndex({
    required String sourceName,
    required String filterName,
    required int filterIndex,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSourceFilterIndex',
      requestData: {
        'sourceName': sourceName,
        'filterName': filterName,
        'filterIndex': filterIndex,
      },
    ),
  );

  /// Sets the enable state of a source filter.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSourceEnabled({
    required String sourceName,
    required String filterName,
    required bool filterEnabled,
  }) async => await setSourceFilterEnabled(
    sourceName: sourceName,
    filterName: filterName,
    filterEnabled: filterEnabled,
  );

  /// Sets the enable state of a source filter.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> setSourceFilterEnabled({
    required String sourceName,
    required String filterName,
    required bool filterEnabled,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetSourceFilterEnabled',
      requestData: {
        'sourceName': sourceName,
        'filterName': filterName,
        'filterEnabled': filterEnabled,
      },
    ),
  );
}
