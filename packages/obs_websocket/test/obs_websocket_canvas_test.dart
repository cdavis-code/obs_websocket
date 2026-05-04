import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('CanvasListResponse parsing', () async {
    final response = json.decode(
      '{"d":{"requestId":"test-uuid","requestStatus":{"code":100,"result":true},"requestType":"GetCanvasList","responseData":{"currentCanvasName":"Main","canvases":[{"canvasFlags":{"ACTIVATE":true,"EPHEMERAL":false,"MAIN":true,"MIX_AUDIO":true,"SCENE_REF":true},"canvasName":"Main","canvasUuid":"6c69626f-6273-4c00-9d88-c5136d61696e","canvasVideoSettings":{"baseHeight":1080,"baseWidth":1920,"fpsDenominator":1,"fpsNumerator":30,"outputHeight":720,"outputWidth":1280}}]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final canvasListResponse = CanvasListResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetCanvasList');
    expect(requestResponse.requestStatus.code, 100);
    expect(canvasListResponse.runtimeType, CanvasListResponse);
    expect(canvasListResponse.currentCanvasName, 'Main');
    expect(canvasListResponse.canvases.length, 1);
    expect(canvasListResponse.canvases[0].canvasName, 'Main');
    expect(
      canvasListResponse.canvases[0].canvasUuid,
      '6c69626f-6273-4c00-9d88-c5136d61696e',
    );
    expect(canvasListResponse.canvases[0].canvasFlags.main, true);
    expect(canvasListResponse.canvases[0].canvasFlags.activate, true);
    expect(canvasListResponse.canvases[0].canvasFlags.ephemeral, false);
    expect(canvasListResponse.canvases[0].canvasFlags.mixAudio, true);
    expect(canvasListResponse.canvases[0].canvasFlags.sceneRef, true);
    expect(canvasListResponse.canvases[0].canvasVideoSettings.baseWidth, 1920);
    expect(canvasListResponse.canvases[0].canvasVideoSettings.baseHeight, 1080);
    expect(
      canvasListResponse.canvases[0].canvasVideoSettings.outputWidth,
      1280,
    );
    expect(
      canvasListResponse.canvases[0].canvasVideoSettings.outputHeight,
      720,
    );
    expect(canvasListResponse.canvases[0].canvasVideoSettings.fpsNumerator, 30);
    expect(
      canvasListResponse.canvases[0].canvasVideoSettings.fpsDenominator,
      1,
    );
  });

  test('CanvasListResponse with multiple canvases', () async {
    final response = json.decode(
      '{"d":{"requestId":"test-uuid","requestStatus":{"code":100,"result":true},"requestType":"GetCanvasList","responseData":{"currentCanvasName":"Main Canvas","canvases":[{"canvasFlags":{"ACTIVATE":true,"EPHEMERAL":false,"MAIN":true,"MIX_AUDIO":true,"SCENE_REF":true},"canvasName":"Main Canvas","canvasUuid":"6c69626f-6273-4c00-9d88-c5136d61696e","canvasVideoSettings":{"baseHeight":1080,"baseWidth":1920,"fpsDenominator":1,"fpsNumerator":30,"outputHeight":720,"outputWidth":1280}},{"canvasFlags":{"ACTIVATE":true,"EPHEMERAL":false,"MAIN":false,"MIX_AUDIO":true,"SCENE_REF":true},"canvasName":"Secondary Canvas","canvasUuid":"7d707370-7384-5d11-ae99-d6247e72707f","canvasVideoSettings":{"baseHeight":720,"baseWidth":1280,"fpsDenominator":1,"fpsNumerator":60,"outputHeight":720,"outputWidth":1280}}]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);
    final requestResponse = RequestResponse.fromJson(opcode.d);
    final canvasListResponse = CanvasListResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(canvasListResponse.currentCanvasName, 'Main Canvas');
    expect(canvasListResponse.canvases.length, 2);
    expect(canvasListResponse.canvases[0].canvasName, 'Main Canvas');
    expect(canvasListResponse.canvases[0].canvasFlags.main, true);
    expect(canvasListResponse.canvases[0].canvasVideoSettings.baseWidth, 1920);
    expect(canvasListResponse.canvases[0].canvasVideoSettings.baseHeight, 1080);
    expect(canvasListResponse.canvases[1].canvasName, 'Secondary Canvas');
    expect(canvasListResponse.canvases[1].canvasFlags.main, false);
    expect(canvasListResponse.canvases[1].canvasVideoSettings.baseWidth, 1280);
    expect(canvasListResponse.canvases[1].canvasVideoSettings.baseHeight, 720);
    expect(canvasListResponse.canvases[1].canvasVideoSettings.fpsNumerator, 60);
  });

  test('Canvas toJson and fromJson', () async {
    final canvas = Canvas(
      canvasFlags: CanvasFlags(
        activate: true,
        ephemeral: false,
        main: true,
        mixAudio: true,
        sceneRef: true,
      ),
      canvasName: 'Test Canvas',
      canvasUuid: '6c69626f-6273-4c00-9d88-c5136d61696e',
      canvasVideoSettings: CanvasVideoSettings(
        baseHeight: 1080,
        baseWidth: 2560,
        fpsDenominator: 1,
        fpsNumerator: 60,
        outputHeight: 1080,
        outputWidth: 2560,
      ),
    );

    final json = canvas.toJson();
    final jsonString = jsonEncode(json);
    final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    final canvasFromJson = Canvas.fromJson(parsedJson);

    expect(canvasFromJson.canvasName, 'Test Canvas');
    expect(canvasFromJson.canvasUuid, '6c69626f-6273-4c00-9d88-c5136d61696e');
    expect(canvasFromJson.canvasFlags.main, true);
    expect(canvasFromJson.canvasVideoSettings.baseWidth, 2560);
    expect(canvasFromJson.canvasVideoSettings.baseHeight, 1080);
    expect(canvasFromJson.canvasVideoSettings.fpsNumerator, 60);
  });

  test('CanvasListResponse toJson and fromJson', () async {
    final response = CanvasListResponse(
      currentCanvasName: 'Main',
      canvases: [
        Canvas(
          canvasFlags: CanvasFlags(
            activate: true,
            ephemeral: false,
            main: true,
            mixAudio: true,
            sceneRef: true,
          ),
          canvasName: 'Main',
          canvasUuid: '6c69626f-6273-4c00-9d88-c5136d61696e',
          canvasVideoSettings: CanvasVideoSettings(
            baseHeight: 1080,
            baseWidth: 1920,
            fpsDenominator: 1,
            fpsNumerator: 30,
            outputHeight: 720,
            outputWidth: 1280,
          ),
        ),
        Canvas(
          canvasFlags: CanvasFlags(
            activate: true,
            ephemeral: false,
            main: false,
            mixAudio: true,
            sceneRef: true,
          ),
          canvasName: 'Secondary',
          canvasUuid: '7d707370-7384-5d11-ae99-d6247e72707f',
          canvasVideoSettings: CanvasVideoSettings(
            baseHeight: 720,
            baseWidth: 1280,
            fpsDenominator: 1,
            fpsNumerator: 60,
            outputHeight: 720,
            outputWidth: 1280,
          ),
        ),
      ],
    );

    // Test that toJson produces valid JSON that can be encoded
    final json = response.toJson();
    final jsonString = jsonEncode(json);

    // Parse back from JSON string
    final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    final responseFromJson = CanvasListResponse.fromJson(parsedJson);

    expect(responseFromJson.currentCanvasName, 'Main');
    expect(responseFromJson.canvases.length, 2);
    expect(responseFromJson.canvases[0].canvasName, 'Main');
    expect(responseFromJson.canvases[1].canvasName, 'Secondary');
  });
}
