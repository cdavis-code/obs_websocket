import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('MediaInputs Tests', () {
    test('GetMediaInputStatus - with inputName parameter', () async {
      final response = json.decode(
        '{"d":{"requestId":"b19b0778-0b46-4cdc-8e27-6285da2b869c","requestStatus":{"code":100,"result":true},"requestType":"GetMediaInputStatus","responseData":{"mediaCursor":0,"mediaDuration":0,"mediaState":"OBS_MEDIA_STATE_PLAYING"}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);
      final mediaInputStatusResponse = MediaInputStatusResponse.fromJson(
        requestResponse.responseData!,
      );

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'GetMediaInputStatus');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(mediaInputStatusResponse.mediaState, ObsMediaState.playing);
      expect(mediaInputStatusResponse.mediaDuration, 0);
      expect(mediaInputStatusResponse.mediaCursor, 0);
    });

    test('GetMediaInputStatus - with inputUuid parameter', () async {
      final response = json.decode(
        '{"d":{"requestId":"b19b0778-0b46-4cdc-8e27-6285da2b869c","requestStatus":{"code":100,"result":true},"requestType":"GetMediaInputStatus","responseData":{"mediaState":"OBS_MEDIA_STATE_PAUSED","mediaDuration":180000,"mediaCursor":90000}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);
      final mediaInputStatusResponse = MediaInputStatusResponse.fromJson(
        requestResponse.responseData!,
      );

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'GetMediaInputStatus');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(mediaInputStatusResponse.mediaState, ObsMediaState.paused);
      expect(mediaInputStatusResponse.mediaDuration, 180000);
      expect(mediaInputStatusResponse.mediaCursor, 90000);
    });

    test('GetMediaInputStatus - stopped state with null values', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-3","requestStatus":{"code":100,"result":true},"requestType":"GetMediaInputStatus","responseData":{"mediaState":"OBS_MEDIA_STATE_STOPPED","mediaDuration":null,"mediaCursor":null}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);
      final mediaInputStatusResponse = MediaInputStatusResponse.fromJson(
        requestResponse.responseData!,
      );

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'GetMediaInputStatus');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(mediaInputStatusResponse.mediaState, ObsMediaState.stopped);
      expect(mediaInputStatusResponse.mediaDuration, null);
      expect(mediaInputStatusResponse.mediaCursor, null);
    });

    test('GetMediaInputStatus - error state', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-4","requestStatus":{"code":100,"result":true},"requestType":"GetMediaInputStatus","responseData":{"mediaState":"OBS_MEDIA_STATE_ERROR","mediaDuration":null,"mediaCursor":null}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);
      final mediaInputStatusResponse = MediaInputStatusResponse.fromJson(
        requestResponse.responseData!,
      );

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'GetMediaInputStatus');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(mediaInputStatusResponse.mediaState, ObsMediaState.error);
      expect(mediaInputStatusResponse.mediaDuration, null);
      expect(mediaInputStatusResponse.mediaCursor, null);
    });

    test('GetMediaInputStatus - buffering state', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-5","requestStatus":{"code":100,"result":true},"requestType":"GetMediaInputStatus","responseData":{"mediaState":"OBS_MEDIA_STATE_BUFFERING","mediaDuration":240000,"mediaCursor":15000}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);
      final mediaInputStatusResponse = MediaInputStatusResponse.fromJson(
        requestResponse.responseData!,
      );

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'GetMediaInputStatus');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(mediaInputStatusResponse.mediaState, ObsMediaState.buffering);
      expect(mediaInputStatusResponse.mediaDuration, 240000);
      expect(mediaInputStatusResponse.mediaCursor, 15000);
    });

    test('SetMediaInputCursor - successful request', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-6","requestStatus":{"code":100,"result":true},"requestType":"SetMediaInputCursor","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'SetMediaInputCursor');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('OffsetMediaInputCursor - with inputName parameter', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-7","requestStatus":{"code":100,"result":true},"requestType":"OffsetMediaInputCursor","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'OffsetMediaInputCursor');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('OffsetMediaInputCursor - with inputUuid parameter', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-8","requestStatus":{"code":100,"result":true},"requestType":"OffsetMediaInputCursor","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'OffsetMediaInputCursor');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('TriggerMediaInputAction - play action', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-9","requestStatus":{"code":100,"result":true},"requestType":"TriggerMediaInputAction","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('TriggerMediaInputAction - pause action', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-10","requestStatus":{"code":100,"result":true},"requestType":"TriggerMediaInputAction","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('TriggerMediaInputAction - stop action', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-11","requestStatus":{"code":100,"result":true},"requestType":"TriggerMediaInputAction","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('TriggerMediaInputAction - restart action', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-12","requestStatus":{"code":100,"result":true},"requestType":"TriggerMediaInputAction","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('TriggerMediaInputAction - next action', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-13","requestStatus":{"code":100,"result":true},"requestType":"TriggerMediaInputAction","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    test('TriggerMediaInputAction - previous action', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-id-14","requestStatus":{"code":100,"result":true},"requestType":"TriggerMediaInputAction","responseData":{}},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 100);
      expect(requestResponse.requestStatus.result, true);
      expect(requestResponse.responseData, isNotNull);
    });

    // Test ObsMediaInputAction enum values
    test('ObsMediaInputAction enum values', () {
      expect(
        ObsMediaInputAction.none.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_NONE',
      );
      expect(
        ObsMediaInputAction.play.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_PLAY',
      );
      expect(
        ObsMediaInputAction.pause.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_PAUSE',
      );
      expect(
        ObsMediaInputAction.stop.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_STOP',
      );
      expect(
        ObsMediaInputAction.restart.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_RESTART',
      );
      expect(
        ObsMediaInputAction.next.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_NEXT',
      );
      expect(
        ObsMediaInputAction.previous.code,
        'OBS_WEBSOCKET_MEDIA_INPUT_ACTION_PREVIOUS',
      );
    });

    // Test ObsMediaState enum values and conversion methods
    test('ObsMediaState enum values and conversion', () {
      expect(ObsMediaState.none.code, 'OBS_MEDIA_STATE_NONE');
      expect(ObsMediaState.playing.code, 'OBS_MEDIA_STATE_PLAYING');
      expect(ObsMediaState.opening.code, 'OBS_MEDIA_STATE_OPENING');
      expect(ObsMediaState.buffering.code, 'OBS_MEDIA_STATE_BUFFERING');
      expect(ObsMediaState.paused.code, 'OBS_MEDIA_STATE_PAUSED');
      expect(ObsMediaState.stopped.code, 'OBS_MEDIA_STATE_STOPPED');
      expect(ObsMediaState.ended.code, 'OBS_MEDIA_STATE_ENDED');
      expect(ObsMediaState.error.code, 'OBS_MEDIA_STATE_ERROR');

      // Test valuesByMessage method
      expect(
        ObsMediaState.valuesByMessage('OBS_MEDIA_STATE_PLAYING'),
        ObsMediaState.playing,
      );
      expect(
        ObsMediaState.valuesByMessage('OBS_MEDIA_STATE_PAUSED'),
        ObsMediaState.paused,
      );
      expect(
        ObsMediaState.valuesByMessage('OBS_MEDIA_STATE_STOPPED'),
        ObsMediaState.stopped,
      );
      expect(
        ObsMediaState.valuesByMessage('OBS_MEDIA_STATE_ERROR'),
        ObsMediaState.error,
      );
      expect(
        ObsMediaState.valuesByMessage('INVALID_STATE'),
        ObsMediaState.none,
      ); // fallback

      // Test toMessage method
      expect(
        ObsMediaState.toMessage(ObsMediaState.playing),
        'OBS_MEDIA_STATE_PLAYING',
      );
      expect(
        ObsMediaState.toMessage(ObsMediaState.paused),
        'OBS_MEDIA_STATE_PAUSED',
      );
      expect(
        ObsMediaState.toMessage(ObsMediaState.stopped),
        'OBS_MEDIA_STATE_STOPPED',
      );
      expect(
        ObsMediaState.toMessage(ObsMediaState.error),
        'OBS_MEDIA_STATE_ERROR',
      );
    });

    // Test MediaInputStatusResponse JSON serialization/deserialization
    test('MediaInputStatusResponse JSON serialization', () {
      final mediaInputStatus = MediaInputStatusResponse(
        mediaState: ObsMediaState.playing,
        mediaDuration: 120000,
        mediaCursor: 45000,
      );

      final json = mediaInputStatus.toJson();
      expect(json['mediaState'], 'OBS_MEDIA_STATE_PLAYING');
      expect(json['mediaDuration'], 120000);
      expect(json['mediaCursor'], 45000);

      final fromJson = MediaInputStatusResponse.fromJson(json);
      expect(fromJson.mediaState, ObsMediaState.playing);
      expect(fromJson.mediaDuration, 120000);
      expect(fromJson.mediaCursor, 45000);
    });

    test('MediaInputStatusResponse JSON serialization with nulls', () {
      final mediaInputStatus = MediaInputStatusResponse(
        mediaState: ObsMediaState.stopped,
        mediaDuration: null,
        mediaCursor: null,
      );

      final json = mediaInputStatus.toJson();
      expect(json['mediaState'], 'OBS_MEDIA_STATE_STOPPED');
      expect(json['mediaDuration'], null);
      expect(json['mediaCursor'], null);

      final fromJson = MediaInputStatusResponse.fromJson(json);
      expect(fromJson.mediaState, ObsMediaState.stopped);
      expect(fromJson.mediaDuration, null);
      expect(fromJson.mediaCursor, null);
    });

    test('MediaInputStatusResponse toString method', () {
      final mediaInputStatus = MediaInputStatusResponse(
        mediaState: ObsMediaState.playing,
        mediaDuration: 120000,
        mediaCursor: 45000,
      );

      final stringOutput = mediaInputStatus.toString();
      expect(stringOutput, isA<String>());
      expect(stringOutput.contains('OBS_MEDIA_STATE_PLAYING'), true);
      expect(stringOutput.contains('120000'), true);
      expect(stringOutput.contains('45000'), true);
    });

    // Error handling tests
    test('GetMediaInputStatus - error response', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-error-1","requestStatus":{"code":600,"result":false,"comment":"Input not found"},"requestType":"GetMediaInputStatus","responseData":null},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'GetMediaInputStatus');
      expect(requestResponse.requestStatus.code, 600);
      expect(requestResponse.requestStatus.result, false);
      expect(requestResponse.requestStatus.comment, 'Input not found');
      expect(requestResponse.responseData, null);
    });

    test('SetMediaInputCursor - error response', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-error-2","requestStatus":{"code":600,"result":false,"comment":"Input not found"},"requestType":"SetMediaInputCursor","responseData":null},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'SetMediaInputCursor');
      expect(requestResponse.requestStatus.code, 600);
      expect(requestResponse.requestStatus.result, false);
      expect(requestResponse.requestStatus.comment, 'Input not found');
      expect(requestResponse.responseData, null);
    });

    test('OffsetMediaInputCursor - error response', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-error-3","requestStatus":{"code":600,"result":false,"comment":"Input not found"},"requestType":"OffsetMediaInputCursor","responseData":null},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'OffsetMediaInputCursor');
      expect(requestResponse.requestStatus.code, 600);
      expect(requestResponse.requestStatus.result, false);
      expect(requestResponse.requestStatus.comment, 'Input not found');
      expect(requestResponse.responseData, null);
    });

    test('TriggerMediaInputAction - error response', () async {
      final response = json.decode(
        '{"d":{"requestId":"test-error-4","requestStatus":{"code":600,"result":false,"comment":"Input not found"},"requestType":"TriggerMediaInputAction","responseData":null},"op":7}',
      );

      final opcode = Opcode.fromJson(response);
      final requestResponse = RequestResponse.fromJson(opcode.d);

      expect(opcode.op, 7);
      expect(requestResponse.requestType, 'TriggerMediaInputAction');
      expect(requestResponse.requestStatus.code, 600);
      expect(requestResponse.requestStatus.result, false);
      expect(requestResponse.requestStatus.comment, 'Input not found');
      expect(requestResponse.responseData, null);
    });
  });
}
