import 'dart:convert';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('ObsDeinterlaceMode', () {
    test('should have correct code values', () {
      expect(ObsDeinterlaceMode.disable.code, 'OBS_DEINTERLACE_MODE_DISABLE');
      expect(ObsDeinterlaceMode.discard.code, 'OBS_DEINTERLACE_MODE_DISCARD');
      expect(ObsDeinterlaceMode.retro.code, 'OBS_DEINTERLACE_MODE_RETRO');
      expect(ObsDeinterlaceMode.blend.code, 'OBS_DEINTERLACE_MODE_BLEND');
      expect(ObsDeinterlaceMode.blend2x.code, 'OBS_DEINTERLACE_MODE_BLEND_2X');
      expect(ObsDeinterlaceMode.linear.code, 'OBS_DEINTERLACE_MODE_LINEAR');
      expect(
        ObsDeinterlaceMode.linear2x.code,
        'OBS_DEINTERLACE_MODE_LINEAR_2X',
      );
      expect(ObsDeinterlaceMode.yadif.code, 'OBS_DEINTERLACE_MODE_YADIF');
      expect(
        ObsDeinterlaceMode.yadif2x.code,
        'OBS_WEBSOCKET_DEINTERLACE_MODE_YADIF_2X',
      );
    });

    test('should convert from code string', () {
      expect(
        ObsDeinterlaceMode.fromCode('OBS_DEINTERLACE_MODE_DISABLE'),
        ObsDeinterlaceMode.disable,
      );
      expect(
        ObsDeinterlaceMode.fromCode('OBS_DEINTERLACE_MODE_BLEND'),
        ObsDeinterlaceMode.blend,
      );
    });

    test('should return disable for unknown code', () {
      expect(
        ObsDeinterlaceMode.fromCode('UNKNOWN_CODE'),
        ObsDeinterlaceMode.disable,
      );
    });

    test('should toString return code', () {
      expect(ObsDeinterlaceMode.blend.toString(), 'OBS_DEINTERLACE_MODE_BLEND');
    });
  });

  group('ObsDeinterlaceFieldOrder', () {
    test('should have correct code values', () {
      expect(
        ObsDeinterlaceFieldOrder.top.code,
        'OBS_DEINTERLACE_FIELD_ORDER_TOP',
      );
      expect(
        ObsDeinterlaceFieldOrder.bottom.code,
        'OBS_DEINTERLACE_FIELD_ORDER_BOTTOM',
      );
    });

    test('should convert from code string', () {
      expect(
        ObsDeinterlaceFieldOrder.fromCode('OBS_DEINTERLACE_FIELD_ORDER_TOP'),
        ObsDeinterlaceFieldOrder.top,
      );
      expect(
        ObsDeinterlaceFieldOrder.fromCode('OBS_DEINTERLACE_FIELD_ORDER_BOTTOM'),
        ObsDeinterlaceFieldOrder.bottom,
      );
    });

    test('should return top for unknown code', () {
      expect(
        ObsDeinterlaceFieldOrder.fromCode('UNKNOWN_CODE'),
        ObsDeinterlaceFieldOrder.top,
      );
    });

    test('should toString return code', () {
      expect(
        ObsDeinterlaceFieldOrder.bottom.toString(),
        'OBS_DEINTERLACE_FIELD_ORDER_BOTTOM',
      );
    });
  });

  group('InputDeinterlaceModeResponse', () {
    test('should parse from JSON', () {
      final json = {'deinterlaceMode': 'OBS_DEINTERLACE_MODE_BLEND'};

      final response = InputDeinterlaceModeResponse.fromJson(json);

      expect(response.deinterlaceMode, ObsDeinterlaceMode.blend);
    });

    test('should convert to JSON', () {
      final response = InputDeinterlaceModeResponse(
        deinterlaceMode: ObsDeinterlaceMode.linear,
      );

      final json = response.toJson();

      expect(json['deinterlaceMode'], 'OBS_DEINTERLACE_MODE_LINEAR');
    });

    test('should handle round-trip serialization', () {
      final response = InputDeinterlaceModeResponse(
        deinterlaceMode: ObsDeinterlaceMode.yadif2x,
      );

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = InputDeinterlaceModeResponse.fromJson(
        parsedJson,
      );

      expect(responseFromJson.deinterlaceMode, response.deinterlaceMode);
    });

    test('should toString return JSON', () {
      final response = InputDeinterlaceModeResponse(
        deinterlaceMode: ObsDeinterlaceMode.disable,
      );

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('OBS_DEINTERLACE_MODE_DISABLE'));
    });
  });

  group('InputDeinterlaceFieldOrderResponse', () {
    test('should parse from JSON', () {
      final json = {
        'deinterlaceFieldOrder': 'OBS_DEINTERLACE_FIELD_ORDER_BOTTOM',
      };

      final response = InputDeinterlaceFieldOrderResponse.fromJson(json);

      expect(response.deinterlaceFieldOrder, ObsDeinterlaceFieldOrder.bottom);
    });

    test('should convert to JSON', () {
      final response = InputDeinterlaceFieldOrderResponse(
        deinterlaceFieldOrder: ObsDeinterlaceFieldOrder.top,
      );

      final json = response.toJson();

      expect(json['deinterlaceFieldOrder'], 'OBS_DEINTERLACE_FIELD_ORDER_TOP');
    });

    test('should handle round-trip serialization', () {
      final response = InputDeinterlaceFieldOrderResponse(
        deinterlaceFieldOrder: ObsDeinterlaceFieldOrder.bottom,
      );

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = InputDeinterlaceFieldOrderResponse.fromJson(
        parsedJson,
      );

      expect(
        responseFromJson.deinterlaceFieldOrder,
        response.deinterlaceFieldOrder,
      );
    });

    test('should toString return JSON', () {
      final response = InputDeinterlaceFieldOrderResponse(
        deinterlaceFieldOrder: ObsDeinterlaceFieldOrder.top,
      );

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('OBS_DEINTERLACE_FIELD_ORDER_TOP'));
    });
  });
}
