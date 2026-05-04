import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('GetStudioModeEnabled', () async {
    final response = json.decode(
      '{"d":{"requestId":"8fcd631b-23c9-4db3-ab4e-161ab67b63d2","requestStatus":{"code":100,"result":true},"requestType":"GetStudioModeEnabled","responseData":{"studioModeEnabled":false}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final result = requestResponse.responseData!;

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetStudioModeEnabled');
    expect(requestResponse.requestStatus.code, 100);
    expect(result['studioModeEnabled'], false);
  });

  test('SetStudioModeEnabled', () async {
    final response = json.decode(
      '{"d":{"requestId":"42e5122e-f4ce-4fa2-a6cf-5e26a16dc7ba","requestStatus":{"code":100,"result":true},"requestType":"SetStudioModeEnabled"},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'SetStudioModeEnabled');
    expect(requestResponse.requestStatus.code, 100);
    expect(requestResponse.requestStatus.result, true);
  });

  test('GetMonitorList', () async {
    final response = json.decode(
      '{"d":{"requestId":"0d317883-c226-4522-8e5e-73ede8a0e4d6","requestStatus":{"code":100,"result":true},"requestType":"GetMonitorList","responseData":{"monitors":[{"monitorHeight":1050,"monitorIndex":0,"monitorName":"Color LCD(0)","monitorPositionX":0,"monitorPositionY":0,"monitorWidth":1680},{"monitorHeight":2160,"monitorIndex":1,"monitorName":"ASUS PB287Q(1)","monitorPositionX":-1075,"monitorPositionY":-2160,"monitorWidth":3840}]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final monitorListResponse = MonitorListResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetMonitorList');
    expect(requestResponse.requestStatus.code, 100);
    expect(monitorListResponse.monitors.isNotEmpty, true);
  });
}
