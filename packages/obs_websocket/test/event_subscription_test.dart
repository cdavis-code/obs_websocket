import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('EventSubscription', () {
    test('canvases has correct value (1 << 11 = 2048)', () {
      expect(EventSubscription.canvases.code, 2048);
      expect(EventSubscription.canvases.code, 1 << 11);
    });

    test('all value includes canvases', () {
      // all should be the sum of all non-high-volume events
      // 1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 + 256 + 512 + 1024 + 2048 = 4095
      expect(EventSubscription.all.code, 4095);

      // Verify that all includes canvases
      expect(
        EventSubscription.all.code & EventSubscription.canvases.code,
        EventSubscription.canvases.code,
      );
    });

    test('canvases can be combined with other subscriptions', () {
      final combined =
          EventSubscription.general.code | EventSubscription.canvases.code;
      expect(combined, 2049); // 1 + 2048

      // Verify both flags are present
      expect(
        combined & EventSubscription.general.code,
        EventSubscription.general.code,
      );
      expect(
        combined & EventSubscription.canvases.code,
        EventSubscription.canvases.code,
      );
    });

    test('canvases bitwise OR operator works', () {
      final combined = EventSubscription.general | EventSubscription.canvases;
      expect(combined, 2049);
    });
  });
}
