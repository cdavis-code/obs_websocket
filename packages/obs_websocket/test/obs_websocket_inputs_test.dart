import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('GetInputList', () async {
    final response = json.decode(
      '{"d":{"requestId":"77caaf39-b4a0-452a-967a-3237fab08097","requestStatus":{"code":100,"result":true},"requestType":"GetInputList","responseData":{"inputs":[{"inputKind":"av_capture_input_v2","inputName":"Video Capture Device","inputUuid":"84217959-3c1e-42e6-96ea-071bab19c4bc","unversionedInputKind":"av_capture_input"},{"inputKind":"ffmpeg_source","inputName":"Media Source","inputUuid":"9f0173bf-301e-4c20-acff-f54fad6dd7e0","unversionedInputKind":"ffmpeg_source"},{"inputKind":"ndi_source","inputName":"iPad NDI","inputUuid":"b8b14106-6784-4332-bdb2-5d0f442ce088","unversionedInputKind":"ndi_source"}]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final inputKindResponse = InputKindResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetInputList');
    expect(requestResponse.requestStatus.code, 100);
    expect(inputKindResponse.inputs.length, 3);
  });

  test('GetInputKindList', () async {
    final response = json.decode(
      '{"d":{"requestId":"4dca61e2-adbc-4b40-94f2-4da35170b574","requestStatus":{"code":100,"result":true},"requestType":"GetInputKindList","responseData":{"inputKinds":["image_source","color_source_v3","slideshow_v2","av_capture_input_v2","macos-avcapture","macos-avcapture-fast","screen_capture","sck_audio_capture","display_capture","window_capture","coreaudio_input_capture","coreaudio_output_capture","syphon-input","browser_source","ffmpeg_source","text_ft2_source_v2","ndi_source"]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final inputKindResponse = StringListResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetInputKindList');
    expect(requestResponse.requestStatus.code, 100);
    expect(inputKindResponse.inputKinds?.length, 17);
  });

  test('GetSpecialInputs', () async {
    final response = json.decode(
      '{"d":{"requestId":"888a33cb-e0e4-4562-b47b-70bfe24dd227","requestStatus":{"code":100,"result":true},"requestType":"GetSpecialInputs","responseData":{"desktop1":null,"desktop2":null,"mic1":null,"mic2":null,"mic3":null,"mic4":null}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final specialInputsResponse = SpecialInputsResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetSpecialInputs');
    expect(requestResponse.requestStatus.code, 100);
    expect(specialInputsResponse.desktop1, null);
  });

  test('CreateInput', () async {
    final response = json.decode(
      '{"d":{"requestId":"1d9dc71e-fb8b-4056-aa31-564518eb0c9a","requestStatus":{"code":100,"result":true},"requestType":"CreateInput","responseData":{"inputUuid":"01834b13-975e-4a9d-a42f-8680568ad83d","sceneItemId":15}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final createInputResponse = CreateInputResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'CreateInput');
    expect(requestResponse.requestStatus.code, 100);
    expect(
      createInputResponse.inputUuid,
      '01834b13-975e-4a9d-a42f-8680568ad83d',
    );
  });

  test('RemoveInput', () async {
    final response = json.decode(
      '{"d":{"requestId":"76153981-fa0e-4a2e-860d-86b2be866a6b","requestStatus":{"code":100,"result":true},"requestType":"RemoveInput"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'RemoveInput');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.responseData, null);
  });

  test('SetInputName', () async {
    final response = json.decode(
      '{"d":{"requestId":"e3b8e062-8059-415b-b79f-dd6d0e995c3e","requestStatus":{"code":100,"result":true},"requestType":"SetInputName"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'SetInputName');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.responseData, null);
  });

  test('GetInputDefaultSettings', () async {
    final response = json.decode(
      '{"d":{"requestId":"e37173ef-5376-49c9-9d0d-0ac55a3d0260","requestStatus":{"code":100,"result":true},"requestType":"GetInputDefaultSettings","responseData":{"defaultInputSettings":{"linear_alpha":false,"unload":false}}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final inputDefaultSettingsResponse = InputDefaultSettingsResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetInputDefaultSettings');
    expect(requestResponse.requestStatus.code, 100);
    expect(
      inputDefaultSettingsResponse.defaultInputSettings,
      json.decode('{"linear_alpha": false, "unload": false}'),
    );
  });

  test('GetInputSettings', () async {
    final response = json.decode(
      '{"d":{"requestId":"425b6f08-ffc5-4d0e-a297-a54b24c08878","requestStatus":{"code":100,"result":true},"requestType":"GetInputSettings","responseData":{"inputKind":"image_source","inputSettings":{"file":"/Users/name/Downloads/Designer.png","linear_alpha":true,"unload":true}}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final inputSettingsResponse = InputSettingsResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetInputSettings');
    expect(requestResponse.requestStatus.code, 100);
    expect(inputSettingsResponse.inputKind, 'image_source');
  });

  test('SetInputSettings', () async {
    final response = json.decode(
      '{"d":{"requestId":"20f3c36e-29b4-4a2b-9326-774c62842f7d","requestStatus":{"code":100,"result":true},"requestType":"SetInputSettings"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'SetInputSettings');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.responseData, null);
  });

  test('GetInputMute', () async {
    final response = json.decode(
      '{"d":{"requestId":"f4c2e9eb-6a65-43de-81bd-ccdd3208770d","requestStatus":{"code":100,"result":true},"requestType":"GetInputMute","responseData":{"inputMuted":false}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final booleanResponse = BooleanResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetInputMute');
    expect(requestResponse.requestStatus.code, 100);
    expect(booleanResponse.enabled, false);
  });

  test('SetInputMute', () async {
    final response = json.decode(
      '{"d":{"requestId":"b58ba08e-adf9-46fb-9cea-c55e0db244fd","requestStatus":{"code":100,"result":true},"requestType":"SetInputMute"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'SetInputMute');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.responseData, null);
  });

  test('ToggleInputMute', () async {
    final response = json.decode(
      '{"d":{"requestId":"4c4483ed-f7a7-4818-a569-79436efc4d7b","requestStatus":{"code":100,"result":true},"requestType":"ToggleInputMute","responseData":{"inputMuted":true}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final booleanResponse = BooleanResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'ToggleInputMute');
    expect(requestResponse.requestStatus.code, 100);
    expect(booleanResponse.inputMuted, true);
  });

  test('GetInputVolume', () async {
    final response = json.decode(
      '{"d":{"requestId":"6e0e75f1-f1e4-4044-a045-772dc7afe027","requestStatus":{"code":100,"result":true},"requestType":"GetInputVolume","responseData":{"inputVolumeDb":0.0,"inputVolumeMul":1.0}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final inputVolumeResponse = InputVolumeResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetInputVolume');
    expect(requestResponse.requestStatus.code, 100);
    expect(inputVolumeResponse.inputVolumeMul, 1.0);
  });
}
