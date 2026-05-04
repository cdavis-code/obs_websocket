import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('GetSceneItemList', () async {
    final response = json.decode(
      '{"d":{"requestId":"a668c967-fa07-4adf-aa62-41ff1be42338","requestStatus":{"code":100,"result":true},"requestType":"GetSceneItemList","responseData":{"sceneItems":[{"inputKind":null,"isGroup":true,"sceneItemBlendMode":"OBS_BLEND_NORMAL","sceneItemEnabled":false,"sceneItemId":2,"sceneItemIndex":0,"sceneItemLocked":false,"sceneItemTransform":{"alignment":5,"boundsAlignment":0,"boundsHeight":0.0,"boundsType":"OBS_BOUNDS_NONE","boundsWidth":0.0,"cropBottom":0,"cropLeft":0,"cropRight":0,"cropTop":0,"height":46.0,"positionX":0.0,"positionY":0.0,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"sourceHeight":46.0,"sourceWidth":269.0,"width":269.0},"sourceName":"Group","sourceType":"OBS_SOURCE_TYPE_SCENE"},{"inputKind":"text_ft2_source_v2","isGroup":null,"sceneItemBlendMode":"OBS_BLEND_NORMAL","sceneItemEnabled":false,"sceneItemId":3,"sceneItemIndex":1,"sceneItemLocked":false,"sceneItemTransform":{"alignment":5,"boundsAlignment":0,"boundsHeight":0.0,"boundsType":"OBS_BOUNDS_NONE","boundsWidth":0.0,"cropBottom":0,"cropLeft":0,"cropRight":0,"cropTop":0,"height":69.0,"positionX":0.0,"positionY":46.0,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"sourceHeight":69.0,"sourceWidth":476.0,"width":476.0},"sourceName":"Text (FreeType 2) 2","sourceType":"OBS_SOURCE_TYPE_INPUT"},{"inputKind":"browser_source","isGroup":null,"sceneItemBlendMode":"OBS_BLEND_NORMAL","sceneItemEnabled":true,"sceneItemId":5,"sceneItemIndex":2,"sceneItemLocked":false,"sceneItemTransform":{"alignment":5,"boundsAlignment":0,"boundsHeight":0.0,"boundsType":"OBS_BOUNDS_NONE","boundsWidth":0.0,"cropBottom":0,"cropLeft":0,"cropRight":0,"cropTop":0,"height":377.0,"positionX":0.0,"positionY":0.0,"rotation":0.0,"scaleX":0.6274999976158142,"scaleY":0.628333330154419,"sourceHeight":600.0,"sourceWidth":800.0,"width":502.0},"sourceName":"obs-browser","sourceType":"OBS_SOURCE_TYPE_INPUT"},{"inputKind":"av_capture_input","isGroup":null,"sceneItemBlendMode":"OBS_BLEND_NORMAL","sceneItemEnabled":false,"sceneItemId":4,"sceneItemIndex":3,"sceneItemLocked":false,"sceneItemTransform":{"alignment":5,"boundsAlignment":0,"boundsHeight":0.0,"boundsType":"OBS_BOUNDS_NONE","boundsWidth":0.0,"cropBottom":0,"cropLeft":0,"cropRight":0,"cropTop":0,"height":809.0,"positionX":0.0,"positionY":0.0,"rotation":0.0,"scaleX":1.123437523841858,"scaleY":1.1236110925674438,"sourceHeight":720.0,"sourceWidth":1280.0,"width":1438.0},"sourceName":"my face","sourceType":"OBS_SOURCE_TYPE_INPUT"}]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final sceneItemListResponse = SceneItemListResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetSceneItemList');
    expect(requestResponse.requestStatus.code, 100);
    expect(sceneItemListResponse.sceneItems.isNotEmpty, true);
  });

  test('GetSceneItemLocked', () async {
    final response = json.decode(
      '{"d":{"requestId":"05213d58-edec-41f7-946b-c8d47161fb6e","requestStatus":{"code":100,"result":true},"requestType":"GetSceneItemLocked","responseData":{"sceneItemLocked":false}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final result = requestResponse.responseData!;

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetSceneItemLocked');
    expect(requestResponse.requestStatus.code, 100);
    expect(result['sceneItemLocked'], false);
  });

  test('SetSceneItemLocked', () async {
    final response = json.decode(
      '{"d":{"requestId":"fd10a14f-3c43-47d2-895d-9e06c61548e8","requestStatus":{"code":100,"result":true},"requestType":"SetSceneItemLocked"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'SetSceneItemLocked');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.requestStatus.result, true);
  });
}
