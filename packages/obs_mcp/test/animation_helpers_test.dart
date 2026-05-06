import 'package:obs_mcp/src/animation_helpers.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('resolveEasing', () {
    test('null and "linear" both return identity', () {
      final a = resolveEasing(null);
      final b = resolveEasing('linear');
      for (final t in <double>[0, 0.25, 0.5, 0.75, 1]) {
        expect(a(t), closeTo(t, 1e-9));
        expect(b(t), closeTo(t, 1e-9));
      }
    });

    test('endpoints are exact for the standard easings', () {
      const easings = <String>[
        'linear',
        'easeIn',
        'easeOut',
        'easeInOut',
        'easeOutBounce',
      ];
      for (final name in easings) {
        final f = resolveEasing(name);
        expect(f(0.0), closeTo(0.0, 1e-9), reason: '$name f(0) == 0');
        expect(f(1.0), closeTo(1.0, 1e-9), reason: '$name f(1) == 1');
      }
    });

    test('easeIn is below linear, easeOut is above linear at midpoint', () {
      expect(resolveEasing('easeIn')(0.5), lessThan(0.5));
      expect(resolveEasing('easeOut')(0.5), greaterThan(0.5));
      expect(resolveEasing('easeInOut')(0.5), closeTo(0.5, 1e-9));
    });

    test('unknown easing names throw', () {
      expect(() => resolveEasing('cubicCustom'), throwsArgumentError);
    });
  });

  group('lerpDouble / lerpInt', () {
    test('lerpDouble interpolates between two values', () {
      expect(lerpDouble(0, 100, 0.0), 0.0);
      expect(lerpDouble(0, 100, 0.5), 50.0);
      expect(lerpDouble(0, 100, 1.0), 100.0);
    });

    test('lerpDouble passes through when one side is null', () {
      expect(lerpDouble(null, 50, 0.5), 50.0);
      expect(lerpDouble(20, null, 0.5), 20.0);
      expect(lerpDouble(null, null, 0.5), isNull);
    });

    test('lerpInt rounds to nearest int', () {
      expect(lerpInt(0, 10, 0.34), 3); // 3.4 → 3
      expect(lerpInt(0, 10, 0.36), 4); // 3.6 → 4
      expect(lerpInt(null, null, 0.5), isNull);
    });
  });

  group('interpolateTransform', () {
    test('numeric fields lerp, non-numeric snap to to-side at first frame', () {
      final from = SceneItemTransform(
        positionX: 0,
        positionY: 0,
        scaleX: 1,
        rotation: 0,
        cropLeft: 0,
        alignment: 5, // topLeft
        boundsType: 'OBS_BOUNDS_NONE',
      );
      final to = SceneItemTransform(
        positionX: 100,
        positionY: 200,
        scaleX: 2,
        rotation: 90,
        cropLeft: 10,
        alignment: 0, // center
        boundsType: 'OBS_BOUNDS_STRETCH',
      );

      final mid = interpolateTransform(from, to, 0.5);
      expect(mid.positionX, 50.0);
      expect(mid.positionY, 100.0);
      expect(mid.scaleX, 1.5);
      expect(mid.rotation, 45.0);
      expect(mid.cropLeft, 5);
      // Non-numeric snap to "to" because it provides a value.
      expect(mid.alignment, 0);
      expect(mid.boundsType, 'OBS_BOUNDS_STRETCH');
    });

    test('fields absent on to retain from values', () {
      final from = SceneItemTransform(positionX: 0, scaleX: 1);
      final to = SceneItemTransform(positionX: 100); // scaleX null
      final mid = interpolateTransform(from, to, 0.5);
      expect(mid.positionX, 50.0);
      expect(mid.scaleX, 1.0); // from-only field retained
    });
  });

  group('parseEventSubscription', () {
    test('mask is returned verbatim when supplied alone', () {
      expect(parseEventSubscription(7, null), 7);
      expect(parseEventSubscription(0, []), 0);
    });

    test('names are OR-combined', () {
      final mask = parseEventSubscription(null, <String>['scenes', 'inputs']);
      expect(
        mask,
        EventSubscription.scenes.code | EventSubscription.inputs.code,
      );
    });

    test('null+empty defaults to "all"', () {
      expect(parseEventSubscription(null, null), EventSubscription.all.code);
      expect(
        parseEventSubscription(null, <String>[]),
        EventSubscription.all.code,
      );
    });

    test('mask + non-empty names is rejected', () {
      expect(
        () => parseEventSubscription(1, <String>['scenes']),
        throwsArgumentError,
      );
    });

    test('unknown subscription names throw', () {
      expect(
        () => parseEventSubscription(null, <String>['notARealGroup']),
        throwsArgumentError,
      );
    });
  });
}
