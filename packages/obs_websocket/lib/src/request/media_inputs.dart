import 'package:obs_websocket/obs_websocket.dart';

/// Media Inputs Requests
class MediaInputs {
  final ObsWebSocket obsWebSocket;

  MediaInputs(this.obsWebSocket);

  /// Gets the status of a media input.
  ///
  /// Media States:
  ///
  /// OBS_MEDIA_STATE_NONE
  /// OBS_MEDIA_STATE_PLAYING
  /// OBS_MEDIA_STATE_OPENING
  /// OBS_MEDIA_STATE_BUFFERING
  /// OBS_MEDIA_STATE_PAUSED
  /// OBS_MEDIA_STATE_STOPPED
  /// OBS_MEDIA_STATE_ENDED
  /// OBS_MEDIA_STATE_ERROR
  ///
  /// Complexity Rating: 2/5
  /// Latest Supported RPC Version: 1
  /// Added in v5.0.0
  ///
  /// **Request Fields:**
  ///
  /// | Name | Type  | Description | Value Restrictions | ?Default Behavior |
  /// | ---- | :---: | ----------- | :----------------: | ----------------- |
  /// | [inputName] | String | Name of the media input | None | Unknown |
  /// | [inputUuid] | String | UUID of the media input | None | Unknown |
  Future<MediaInputStatusResponse> getMediaInputStatus({
    String? inputName,
    String? inputUuid,
  }) async {
    final response = await obsWebSocket.sendRequest(
      Request(
        'GetMediaInputStatus',
        requestData: {'inputName': inputName, 'inputUuid': inputUuid},
      ),
    );

    final mediaInputStatusResponse = MediaInputStatusResponse.fromJson(
      response!.responseData!,
    );

    return mediaInputStatusResponse;
  }

  /// Sets the cursor position of a media input.
  ///
  /// This request does not perform bounds checking of the cursor position.
  ///
  /// - Complexity Rating: 1/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  /// **Request Fields:**
  ///
  /// | Name | Type  | Description | Value Restrictions | ?Default Behavior |
  /// | ---- | :---: | ----------- | :----------------: | ----------------- |
  /// | [inputName] | String | Name of the media input | None | N/A |
  /// | [mediaCursor] | Number | New cursor position to set | >= 0 | N/A |
  Future<void> setMediaInputCursor({
    String? inputName,
    String? inputUuid,
    required int mediaCursor,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'SetMediaInputCursor',
      requestData: {
        'inputName': inputName,
        'inputUuid': inputUuid,
        'mediaCursor': mediaCursor,
      },
    ),
  );

  /// Offsets the current cursor position of a media input by the specified value.
  ///
  /// This request does not perform bounds checking of the cursor position.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  /// **Request Fields:**
  ///
  /// | Name | Type  | Description | Value Restrictions | ?Default Behavior |
  /// | ---- | :---: | ----------- | :----------------: | ----------------- |
  /// | [inputName] | String | Name of the media input | None | Unknown |
  /// | [inputName] | String | UUID of the media input | None | Unknown |
  /// | [mediaCursorOffset] | Number | Value to offset the current cursor position by | None | N/A |
  Future<void> offsetMediaInputCursor({
    String? inputName,
    String? inputUuid,
    required int mediaCursorOffset,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'OffsetMediaInputCursor',
      requestData: {
        'inputName': inputName,
        'inputUuid': inputUuid,
        'mediaCursorOffset': mediaCursorOffset,
      },
    ),
  );

  /// Triggers an action on a media input.
  ///
  /// - Complexity Rating: 2/5
  /// - Latest Supported RPC Version: 1
  /// - Added in v5.0.0
  /// **Request Fields:**
  ///
  /// | Name | Type  | Description | Value Restrictions | ?Default Behavior |
  /// | ---- | :---: | ----------- | :----------------: | ----------------- |
  /// | [inputName] | String | Name of the media input | None | Unknown |
  /// | [inputUuid] | String | UUID of the media input | None | Unknown |
  /// | [mediaAction] | String | String	Identifier of the ObsMediaInputAction enum | None | N/A |
  Future<void> triggerMediaInputAction({
    String? inputName,
    String? inputUuid,
    required ObsMediaInputAction mediaAction,
  }) async => await obsWebSocket.sendRequest(
    Request(
      'TriggerMediaInputAction',
      requestData: {
        'inputName': inputName,
        'inputUuid': inputUuid,
        'mediaAction': mediaAction.code,
      },
    ),
  );
}
