import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('ObsMonitoringType', () {
    test('should have correct code values', () {
      expect(ObsMonitoringType.none.code, 'OBS_MONITORING_TYPE_NONE');
      expect(
        ObsMonitoringType.monitorOnly.code,
        'OBS_MONITORING_TYPE_MONITOR_ONLY',
      );
      expect(
        ObsMonitoringType.monitorAndOutput.code,
        'OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT',
      );
    });

    test('should convert from code string', () {
      expect(
        ObsMonitoringType.fromCode('OBS_MONITORING_TYPE_NONE'),
        ObsMonitoringType.none,
      );
      expect(
        ObsMonitoringType.fromCode('OBS_MONITORING_TYPE_MONITOR_ONLY'),
        ObsMonitoringType.monitorOnly,
      );
      expect(
        ObsMonitoringType.fromCode('OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT'),
        ObsMonitoringType.monitorAndOutput,
      );
    });

    test('should return none for unknown code', () {
      expect(
        ObsMonitoringType.fromCode('UNKNOWN_CODE'),
        ObsMonitoringType.none,
      );
    });

    test('should toString return code', () {
      expect(
        ObsMonitoringType.monitorOnly.toString(),
        'OBS_MONITORING_TYPE_MONITOR_ONLY',
      );
    });
  });

  group('InputAudioBalanceResponse', () {
    test('should parse from JSON', () {
      final json = {'inputAudioBalance': 0.5};

      final response = InputAudioBalanceResponse.fromJson(json);

      expect(response.inputAudioBalance, 0.5);
    });

    test('should convert to JSON', () {
      final response = InputAudioBalanceResponse(inputAudioBalance: 0.75);

      final json = response.toJson();

      expect(json['inputAudioBalance'], 0.75);
    });

    test('should handle round-trip serialization', () {
      final response = InputAudioBalanceResponse(inputAudioBalance: 0.25);

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = InputAudioBalanceResponse.fromJson(parsedJson);

      expect(responseFromJson.inputAudioBalance, response.inputAudioBalance);
    });

    test('should toString return JSON', () {
      final response = InputAudioBalanceResponse(inputAudioBalance: 0.5);

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('0.5'));
    });
  });

  group('InputAudioSyncOffsetResponse', () {
    test('should parse from JSON', () {
      final json = {'inputAudioSyncOffset': 150};

      final response = InputAudioSyncOffsetResponse.fromJson(json);

      expect(response.inputAudioSyncOffset, 150);
    });

    test('should convert to JSON', () {
      final response = InputAudioSyncOffsetResponse(inputAudioSyncOffset: -200);

      final json = response.toJson();

      expect(json['inputAudioSyncOffset'], -200);
    });

    test('should handle round-trip serialization', () {
      final response = InputAudioSyncOffsetResponse(inputAudioSyncOffset: 100);

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = InputAudioSyncOffsetResponse.fromJson(
        parsedJson,
      );

      expect(
        responseFromJson.inputAudioSyncOffset,
        response.inputAudioSyncOffset,
      );
    });

    test('should toString return JSON', () {
      final response = InputAudioSyncOffsetResponse(inputAudioSyncOffset: 50);

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('50'));
    });
  });

  group('InputAudioMonitorTypeResponse', () {
    test('should parse from JSON', () {
      final json = {'monitorType': 'OBS_MONITORING_TYPE_MONITOR_ONLY'};

      final response = InputAudioMonitorTypeResponse.fromJson(json);

      expect(response.monitorType, ObsMonitoringType.monitorOnly);
    });

    test('should convert to JSON', () {
      final response = InputAudioMonitorTypeResponse(
        monitorType: ObsMonitoringType.monitorAndOutput,
      );

      final json = response.toJson();

      expect(json['monitorType'], 'OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT');
    });

    test('should handle round-trip serialization', () {
      final response = InputAudioMonitorTypeResponse(
        monitorType: ObsMonitoringType.none,
      );

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = InputAudioMonitorTypeResponse.fromJson(
        parsedJson,
      );

      expect(responseFromJson.monitorType, response.monitorType);
    });

    test('should toString return JSON', () {
      final response = InputAudioMonitorTypeResponse(
        monitorType: ObsMonitoringType.monitorOnly,
      );

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('OBS_MONITORING_TYPE_MONITOR_ONLY'));
    });
  });

  group('InputAudioTracksResponse', () {
    test('should parse from JSON', () {
      final json = {'inputAudioTracks': 3};

      final response = InputAudioTracksResponse.fromJson(json);

      expect(response.inputAudioTracks, 3);
    });

    test('should convert to JSON', () {
      final response = InputAudioTracksResponse(inputAudioTracks: 7);

      final json = response.toJson();

      expect(json['inputAudioTracks'], 7);
    });

    test('should handle round-trip serialization', () {
      final response = InputAudioTracksResponse(inputAudioTracks: 15);

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = InputAudioTracksResponse.fromJson(parsedJson);

      expect(responseFromJson.inputAudioTracks, response.inputAudioTracks);
    });

    test('should toString return JSON', () {
      final response = InputAudioTracksResponse(inputAudioTracks: 1);

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('1'));
    });
  });

  group('PropertyItem', () {
    test('should parse from JSON', () {
      final json = {
        'itemValue': 'value1',
        'itemText': 'Display Text',
        'itemEnabled': true,
      };

      final item = PropertyItem.fromJson(json);

      expect(item.itemValue, 'value1');
      expect(item.itemText, 'Display Text');
      expect(item.itemEnabled, true);
    });

    test('should convert to JSON', () {
      final item = PropertyItem(
        itemValue: 'value2',
        itemText: 'Another Text',
        itemEnabled: false,
      );

      final json = item.toJson();

      expect(json['itemValue'], 'value2');
      expect(json['itemText'], 'Another Text');
      expect(json['itemEnabled'], false);
    });

    test('should handle round-trip serialization', () {
      final item = PropertyItem(
        itemValue: 'test',
        itemText: 'Test Item',
        itemEnabled: true,
      );

      final json = item.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final itemFromJson = PropertyItem.fromJson(parsedJson);

      expect(itemFromJson.itemValue, item.itemValue);
      expect(itemFromJson.itemText, item.itemText);
      expect(itemFromJson.itemEnabled, item.itemEnabled);
    });

    test('should toString return JSON', () {
      final item = PropertyItem(
        itemValue: 'value',
        itemText: 'Text',
        itemEnabled: true,
      );

      final result = item.toString();

      expect(result, isA<String>());
      expect(result, contains('value'));
      expect(result, contains('Text'));
    });
  });

  group('InputPropertiesListPropertyItemsResponse', () {
    test('should parse from JSON', () {
      final json = {
        'propertyItems': [
          {'itemValue': 'item1', 'itemText': 'Item 1', 'itemEnabled': true},
          {'itemValue': 'item2', 'itemText': 'Item 2', 'itemEnabled': false},
        ],
      };

      final response = InputPropertiesListPropertyItemsResponse.fromJson(json);

      expect(response.propertyItems.length, 2);
      expect(response.propertyItems[0].itemValue, 'item1');
      expect(response.propertyItems[1].itemText, 'Item 2');
    });

    test('should convert to JSON', () {
      final response = InputPropertiesListPropertyItemsResponse(
        propertyItems: [
          PropertyItem(
            itemValue: 'val1',
            itemText: 'Text 1',
            itemEnabled: true,
          ),
        ],
      );

      final json = response.toJson();

      expect(json['propertyItems'], isA<List<dynamic>>());
      expect((json['propertyItems'] as List).length, 1);
      expect((json['propertyItems'] as List)[0]['itemValue'], 'val1');
    });

    test('should handle round-trip serialization', () {
      final response = InputPropertiesListPropertyItemsResponse(
        propertyItems: [
          PropertyItem(itemValue: 'test', itemText: 'Test', itemEnabled: true),
        ],
      );

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson =
          InputPropertiesListPropertyItemsResponse.fromJson(parsedJson);

      expect(responseFromJson.propertyItems.length, 1);
      expect(
        responseFromJson.propertyItems[0].itemValue,
        response.propertyItems[0].itemValue,
      );
    });

    test('should toString return JSON', () {
      final response = InputPropertiesListPropertyItemsResponse(
        propertyItems: [
          PropertyItem(
            itemValue: 'item',
            itemText: 'Item Text',
            itemEnabled: true,
          ),
        ],
      );

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('item'));
      expect(result, contains('Item Text'));
    });
  });
}
