import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('GetPersistentData', () async {
    final response = json.decode(
      '{"d":{"requestId":"d1a544ff-1a97-4227-9771-25044041286e","requestStatus":{"code":100,"result":true},"requestType":"GetPersistentData","responseData":{"slotValue":null}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final result = requestResponse.responseData!;

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetPersistentData');
    expect(requestResponse.requestStatus.code, 100);
    expect(result['slotValue'], null);
  });

  test('SetPersistentData', () async {
    final response = json.decode(
      '{"d":{"requestId":"ca1d92c6-867a-4041-b303-ed07c9f372e7","requestStatus":{"code":100,"result":true},"requestType":"SetPersistentData"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'SetPersistentData');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.requestStatus.result, true);
  });

  test('GetSceneCollectionList', () async {
    final response = json.decode(
      '{"d":{"requestId":"7f33121c-e4ad-4734-9b8f-71b33328d9af","requestStatus":{"code":100,"result":true},"requestType":"GetSceneCollectionList","responseData":{"currentSceneCollectionName":"testColl","sceneCollections":["Untitled","testColl"]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final sceneCollectionListResponse = SceneCollectionListResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetSceneCollectionList');
    expect(requestResponse.requestStatus.code, 100);
    expect(sceneCollectionListResponse.currentSceneCollectionName, 'testColl');
  });
}
