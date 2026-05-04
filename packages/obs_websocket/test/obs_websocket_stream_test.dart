import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('GetStreamStatus', () async {
    final response = json.decode(
      '{"d":{"requestId":"80cf6055-23be-4241-982f-b75ef6194047","requestStatus":{"code":100,"result":true},"requestType":"GetStreamStatus","responseData":{"outputActive":false,"outputBytes":0,"outputCongestion":0.0,"outputDuration":0,"outputReconnecting":false,"outputSkippedFrames":0,"outputTimecode":"00:00:00.000","outputTotalFrames":0}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final streamStatusResponse = StreamStatusResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetStreamStatus');
    expect(requestResponse.requestStatus.code, 100);
    expect(streamStatusResponse.runtimeType, StreamStatusResponse);
  });
}
