import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_version_command.dart';
import 'package:test/test.dart';

void main() {
  group('ObsVersionCommand', () {
    test('exposes the expected name and description', () {
      final cmd = ObsVersionCommand();
      expect(cmd.name, 'version');
      expect(cmd.description, isNotEmpty);
    });

    test('embeds the published package name and version', () {
      expect(ObsVersionCommand.packageName, 'obs_cli');
      expect(ObsVersionCommand.packageVersion, matches(RegExp(r'^\d+\.\d+')));
    });

    test('registers cleanly under a CommandRunner', () async {
      final runner = CommandRunner<void>('obs', 'test')
        ..addCommand(ObsVersionCommand());

      expect(runner.commands.keys, contains('version'));
      // Running should not throw and should produce output on stdout
      // (captured by the test harness when needed, but here we just
      // verify the happy-path doesn't error).
      await runner.run(['version']);
    });
  });
}
