import 'package:obs_websocket/obs_websocket.dart';

/// General Requests
class General {
  final ObsWebSocket obsWebSocket;

  General(this.obsWebSocket);

  /// Gets data about the current plugin and RPC version.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<VersionResponse> get version async => await getVersion();

  /// Gets data about the current plugin and RPC version.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<VersionResponse> getVersion() async {
    final response = await obsWebSocket.sendRequest(Request('GetVersion'));

    return VersionResponse.fromJson(response!.responseData!);
  }

  /// Gets statistics about OBS, obs-websocket, and the current session.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StatsResponse> get stats async => await getStats();

  /// Gets statistics about OBS, obs-websocket, and the current session.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<StatsResponse> getStats() async {
    final response = await obsWebSocket.sendRequest(Request('GetStats'));

    return StatsResponse.fromJson(response!.responseData!);
  }

  /// Broadcasts a CustomEvent to all WebSocket clients. Receivers are clients which are identified and subscribed.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> broadcastCustomEvent(Map<String, dynamic> arg) async =>
      await obsWebSocket.sendRequest(
        Request('BroadcastCustomEvent', requestData: arg),
      );

  /// Call a request registered to a vendor.
  ///
  /// A vendor is a unique name registered by a third-party plugin or script, which allows for custom requests and events to be added to obs-websocket. If a plugin or script implements vendor requests or events, documentation is expected to be provided with them.
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<CallVendorRequestResponse> callVendorRequest({
    required String vendorName,
    required String requestType,
    RequestData? requestData,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'CallVendorRequest',
        requestData: {
          'vendorName': vendorName,
          'requestType': requestType,
          'requestData': requestData?.toJson(),
        },
      ),
    );

    return CallVendorRequestResponse.fromJson(response!.responseData!);
  }

  /// Helper method to send a VendorRequest specifically to the 'obs-browser' plugin.
  Future<CallVendorRequestResponse> obsBrowserEvent({
    required String eventName,
    dynamic eventData,
  }) async => await callVendorRequest(
    vendorName: 'obs-browser',
    requestType: 'emit_event',
    requestData: RequestData(eventName: eventName, eventData: eventData),
  );

  /// Gets an array of all hotkey names in OBS
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<String>> get hotkeyList async => await getHotkeyList();

  /// Gets an array of all hotkey names in OBS
  ///
  /// - Complexity Rating: 3/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<List<String>> getHotkeyList() async {
    final response = await obsWebSocket.sendRequest(Request('GetHotkeyList'));

    return StringListResponse.fromJson(response!.responseData!).items;
  }

  Future<void> triggerHotkeyByName(String hotkeyName) async {
    await obsWebSocket.sendRequest(
      Request('TriggerHotkeyByName', requestData: {'hotkeyName': hotkeyName}),
    );
  }

  /// Triggers a hotkey using a sequence of keys.
  ///
  /// - Complexity Rating: 4/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> triggerHotkeyByKeySequence({
    String? keyId,
    KeyModifiers? keyModifiers,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'TriggerHotkeyByKeySequence',
      requestData: {'keyId': keyId, 'keyModifiers': keyModifiers?.toJson()},
    ),
  );

  /// Sleeps for a time duration or number of frames. Only available in request batches with types SERIAL_REALTIME or SERIAL_FRAME.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  Future<void> sleep({int? sleepMillis, int? sleepFrames}) async =>
      await obsWebSocket.sendRequest(
        Request(
          'Sleep',
          requestData: {'sleepMillis': sleepMillis, 'sleepFrames': sleepFrames},
        ),
      );
}
