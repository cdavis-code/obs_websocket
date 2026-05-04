import 'dart:convert';

import 'package:obs_websocket/event.dart';
import 'package:test/test.dart';

void main() {
  group('Canvas Events', () {
    test('CanvasCreated parsing', () {
      final json = {
        'canvasName': 'Main Canvas',
        'canvasUuid': '6c69626f-6273-4c00-9d88-c5136d61696e',
      };

      final event = CanvasCreated.fromJson(json);

      expect(event.canvasName, 'Main Canvas');
      expect(event.canvasUuid, '6c69626f-6273-4c00-9d88-c5136d61696e');
    });

    test('CanvasRemoved parsing', () {
      final json = {
        'canvasName': 'Secondary Canvas',
        'canvasUuid': '7d707370-7384-5d11-ae99-d6247e72707f',
      };

      final event = CanvasRemoved.fromJson(json);

      expect(event.canvasName, 'Secondary Canvas');
      expect(event.canvasUuid, '7d707370-7384-5d11-ae99-d6247e72707f');
    });

    test('CanvasNameChanged parsing', () {
      final json = {
        'canvasName': 'New Canvas Name',
        'canvasUuid': '6c69626f-6273-4c00-9d88-c5136d61696e',
        'oldCanvasName': 'Old Canvas Name',
      };

      final event = CanvasNameChanged.fromJson(json);

      expect(event.canvasName, 'New Canvas Name');
      expect(event.canvasUuid, '6c69626f-6273-4c00-9d88-c5136d61696e');
      expect(event.oldCanvasName, 'Old Canvas Name');
    });

    test('CanvasCreated toJson and fromJson round trip', () {
      final event = CanvasCreated(
        canvasName: 'Test Canvas',
        canvasUuid: '6c69626f-6273-4c00-9d88-c5136d61696e',
      );

      final json = event.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final eventFromJson = CanvasCreated.fromJson(parsedJson);

      expect(eventFromJson.canvasName, 'Test Canvas');
      expect(eventFromJson.canvasUuid, '6c69626f-6273-4c00-9d88-c5136d61696e');
    });

    test('CanvasNameChanged toJson and fromJson round trip', () {
      final event = CanvasNameChanged(
        canvasName: 'New Name',
        canvasUuid: '6c69626f-6273-4c00-9d88-c5136d61696e',
        oldCanvasName: 'Old Name',
      );

      final json = event.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final eventFromJson = CanvasNameChanged.fromJson(parsedJson);

      expect(eventFromJson.canvasName, 'New Name');
      expect(eventFromJson.canvasUuid, '6c69626f-6273-4c00-9d88-c5136d61696e');
      expect(eventFromJson.oldCanvasName, 'Old Name');
    });

    test('CanvasCreated toString produces valid JSON', () {
      final event = CanvasCreated(
        canvasName: 'Main',
        canvasUuid: '6c69626f-6273-4c00-9d88-c5136d61696e',
      );

      final str = event.toString();
      final parsed = jsonDecode(str) as Map<String, dynamic>;

      expect(parsed['canvasName'], 'Main');
      expect(parsed['canvasUuid'], '6c69626f-6273-4c00-9d88-c5136d61696e');
    });
  });
}
