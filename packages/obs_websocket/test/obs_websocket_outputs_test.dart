import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('ToggleReplayBuffer', () async {
    final response = json.decode(
      '{"d":{"requestId":"65bd6190-ccf8-4ba2-a851-2a505515d97d","requestStatus":{"code":100,"result":true},"requestType":"ToggleReplayBuffer","responseData":{"outputActive":false}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final result = requestResponse.responseData!;

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'ToggleReplayBuffer');
    expect(requestResponse.requestStatus.code, 100);
    expect(result['outputActive'], false);
  });
}
