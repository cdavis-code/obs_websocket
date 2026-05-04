import 'package:obs_cli/src/cmd/obs_helper_command.dart';
import 'package:test/test.dart';

/// Concrete subclass so we can exercise the protected `parseDotenv` method
/// without mocking the full command runner.
class _Harness extends ObsHelperCommand {
  @override
  String get description => 'test harness';
  @override
  String get name => 'harness';
}

void main() {
  final harness = _Harness();

  group('parseDotenv', () {
    test('parses simple KEY=VALUE pairs', () {
      final result = harness.parseDotenv('FOO=bar\nBAZ=qux');
      expect(result, {'FOO': 'bar', 'BAZ': 'qux'});
    });

    test('ignores blank lines and # comments', () {
      final contents = '''
# a comment
FOO=bar

# another
BAZ=qux
''';
      final result = harness.parseDotenv(contents);
      expect(result, {'FOO': 'bar', 'BAZ': 'qux'});
    });

    test('strips surrounding double and single quotes', () {
      final result = harness.parseDotenv('A="double"\nB=\'single\'');
      expect(result, {'A': 'double', 'B': 'single'});
    });

    test('supports export KEY=VALUE prefix', () {
      final result = harness.parseDotenv('export FOO=bar');
      expect(result, {'FOO': 'bar'});
    });

    test('trims trailing inline comment on unquoted values', () {
      final result = harness.parseDotenv('FOO=bar # trailing');
      expect(result, {'FOO': 'bar'});
    });

    test('keeps inline # inside quoted values', () {
      final result = harness.parseDotenv('FOO="bar # kept"');
      expect(result, {'FOO': 'bar # kept'});
    });

    test('skips malformed lines without "="', () {
      final result = harness.parseDotenv('NO_EQUALS\nFOO=bar');
      expect(result, {'FOO': 'bar'});
    });

    test('skips lines where key is empty (=value)', () {
      final result = harness.parseDotenv('=orphan\nFOO=bar');
      expect(result, {'FOO': 'bar'});
    });
  });
}
