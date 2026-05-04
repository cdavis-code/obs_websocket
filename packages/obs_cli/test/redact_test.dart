import 'package:obs_cli/src/util/redact.dart';
import 'package:test/test.dart';

void main() {
  group('isSensitiveKey', () {
    test('matches common secret key names (case-insensitive)', () {
      expect(isSensitiveKey('password'), isTrue);
      expect(isSensitiveKey('PASSWORD'), isTrue);
      expect(isSensitiveKey('OBS_WEBSOCKET_PASSWORD'), isTrue);
      expect(isSensitiveKey('AuthToken'), isTrue);
      expect(isSensitiveKey('api_key'), isTrue);
    });

    test('does not flag non-sensitive keys', () {
      expect(isSensitiveKey('uri'), isFalse);
      expect(isSensitiveKey('host'), isFalse);
      expect(isSensitiveKey('scene_name'), isFalse);
    });
  });

  group('redactSecrets', () {
    test('replaces top-level secret values with ***', () {
      final input = {'uri': 'ws://localhost:4455', 'password': 'hunter2'};
      expect(redactSecrets(input), {
        'uri': 'ws://localhost:4455',
        'password': '***',
      });
    });

    test('walks nested maps', () {
      final input = {
        'outer': {
          'password': 'hunter2',
          'inner': {'token': 'abc'},
        },
      };
      expect(redactSecrets(input), {
        'outer': {
          'password': '***',
          'inner': {'token': '***'},
        },
      });
    });

    test('walks lists recursively', () {
      final input = [
        {'password': 'a'},
        {'other': 'keep'},
      ];
      expect(redactSecrets(input), [
        {'password': '***'},
        {'other': 'keep'},
      ]);
    });

    test('returns primitives unchanged', () {
      expect(redactSecrets('hello'), 'hello');
      expect(redactSecrets(42), 42);
      expect(redactSecrets(null), isNull);
    });
  });
}
