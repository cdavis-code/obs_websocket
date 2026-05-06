import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('SceneItemTransform', () {
    test('fromJson coerces ints to doubles for float fields', () {
      final t = SceneItemTransform.fromJson(<String, dynamic>{
        'positionX': 100,
        'positionY': 200.5,
        'scaleX': 1,
        'rotation': 0,
        'cropLeft': 4,
      });

      expect(t.positionX, 100.0);
      expect(t.positionY, 200.5);
      expect(t.scaleX, 1.0);
      expect(t.rotation, 0.0);
      expect(t.cropLeft, 4);
      expect(t.scaleY, isNull);
    });

    test('toJson omits null fields', () {
      final t = SceneItemTransform(positionX: 10, scaleX: 2);
      final json = t.toJson();
      expect(json.keys, unorderedEquals(<String>['positionX', 'scaleX']));
      expect(json['positionX'], 10.0);
      expect(json['scaleX'], 2.0);
    });

    test('fromJsonStrict rejects unknown keys', () {
      expect(
        () => SceneItemTransform.fromJsonStrict(<String, dynamic>{
          'positionX': 100,
          'unknownField': 'oops',
        }),
        throwsA(isA<ObsArgumentException>()),
      );
    });

    test('fromJsonStrict accepts the full known key set', () {
      final t = SceneItemTransform.fromJsonStrict(<String, dynamic>{
        'positionX': 1,
        'positionY': 2,
        'scaleX': 3,
        'scaleY': 4,
        'rotation': 5,
        'cropLeft': 6,
        'cropTop': 7,
        'cropRight': 8,
        'cropBottom': 9,
        'alignment': 5,
        'boundsAlignment': 0,
        'boundsType': 'OBS_BOUNDS_NONE',
        'boundsWidth': 100,
        'boundsHeight': 200,
        'sourceWidth': 1920,
        'sourceHeight': 1080,
        'width': 960,
        'height': 540,
      });
      expect(t.alignment, 5);
      expect(t.boundsType, 'OBS_BOUNDS_NONE');
      expect(t.boundsWidth, 100.0);
      expect(t.sourceWidth, 1920.0);
    });

    test('merge prefers non-null fields from other', () {
      final base = SceneItemTransform(positionX: 10, positionY: 20, scaleX: 1);
      final patch = SceneItemTransform(positionY: 999, scaleY: 2);
      final merged = base.merge(patch);
      expect(merged.positionX, 10.0); // unchanged
      expect(merged.positionY, 999.0); // overridden
      expect(merged.scaleX, 1.0); // unchanged
      expect(merged.scaleY, 2.0); // added
    });

    test('copyWith leaves other fields untouched', () {
      final base = SceneItemTransform(positionX: 10, rotation: 90);
      final next = base.copyWith(rotation: 180);
      expect(next.positionX, 10.0);
      expect(next.rotation, 180.0);
    });
  });

  group('Bounds + alignment enums', () {
    test('ObsAlignment values cover OBS bit-flag corners', () {
      expect(ObsAlignment.center.code, 0);
      expect(ObsAlignment.topLeft.code, 5);
      expect(ObsAlignment.bottomRight.code, 10);
    });

    test(
      'ObsAlignment.fromCode round-trips known values and rejects unknown',
      () {
        for (final value in ObsAlignment.values) {
          expect(ObsAlignment.fromCode(value.code), value);
        }
        expect(ObsAlignment.fromCode(9999), isNull);
      },
    );

    test('ObsBoundsType code round-trips via fromCode', () {
      for (final type in ObsBoundsType.values) {
        expect(ObsBoundsType.fromCode(type.code), type);
      }
    });

    test('ObsBoundsType.fromCode returns null for unknown values', () {
      expect(ObsBoundsType.fromCode('OBS_BOUNDS_BOGUS'), isNull);
    });
  });
}
