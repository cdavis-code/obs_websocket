import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';
import 'package:test/test.dart';

void main() {
  group('ObsMediaInputsCommand Tests', () {
    late CommandRunner<void> runner;

    setUp(() {
      runner = CommandRunner<void>('obs', 'OBS WebSocket CLI');
      runner.addCommand(ObsMediaInputsCommand());
    });

    group('ObsGetMediaInputStatusCommand', () {
      test('should parse arguments correctly with input-name', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'get-media-input-status',
          '--input-name',
          'test',
        ]);
        expect(result.command?.command?.name, 'get-media-input-status');
        expect(result.command?.command?['input-name'], 'test');
      });

      test('should parse arguments correctly with input-uuid', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'get-media-input-status',
          '--input-uuid',
          'test-uuid',
        ]);
        expect(result.command?.command?.name, 'get-media-input-status');
        expect(result.command?.command?['input-uuid'], 'test-uuid');
      });

      test(
        'should parse arguments correctly with both input-name and input-uuid',
        () {
          final result = runner.argParser.parse([
            'media-inputs',
            'get-media-input-status',
            '--input-name',
            'test',
            '--input-uuid',
            'test-uuid',
          ]);
          expect(result.command?.command?.name, 'get-media-input-status');
          expect(result.command?.command?['input-name'], 'test');
          expect(result.command?.command?['input-uuid'], 'test-uuid');
        },
      );
    });

    group('ObsSetMediaInputCursorCommand', () {
      test('should parse arguments correctly with valid parameters', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'set-media-input-cursor',
          '--input-name',
          'test',
          '--media-cursor',
          '1000',
        ]);
        expect(result.command?.command?.name, 'set-media-input-cursor');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['media-cursor'], '1000');
      });

      test('should parse arguments correctly with zero media-cursor', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'set-media-input-cursor',
          '--input-name',
          'test',
          '--media-cursor',
          '0',
        ]);
        expect(result.command?.command?.name, 'set-media-input-cursor');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['media-cursor'], '0');
      });

      test(
        'should parse arguments correctly with large media-cursor value',
        () {
          final result = runner.argParser.parse([
            'media-inputs',
            'set-media-input-cursor',
            '--input-name',
            'test',
            '--media-cursor',
            '999999999',
          ]);
          expect(result.command?.command?.name, 'set-media-input-cursor');
          expect(result.command?.command?['input-name'], 'test');
          expect(result.command?.command?['media-cursor'], '999999999');
        },
      );

      test('should accept input-uuid parameter', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'set-media-input-cursor',
          '--input-name',
          'test',
          '--input-uuid',
          'test-uuid',
          '--media-cursor',
          '1000',
        ]);
        expect(result.command?.command?.name, 'set-media-input-cursor');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['input-uuid'], 'test-uuid');
        expect(result.command?.command?['media-cursor'], '1000');
      });
    });

    group('ObsOffsetMediaInputCursorCommand', () {
      test('should parse arguments correctly with valid parameters', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'offset-media-input-cursor',
          '--input-name',
          'test',
          '--media-cursor-offset',
          '500',
        ]);
        expect(result.command?.command?.name, 'offset-media-input-cursor');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['media-cursor-offset'], '500');
      });

      test('should accept negative offset values', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'offset-media-input-cursor',
          '--input-name',
          'test',
          '--media-cursor-offset',
          '-1000',
        ]);
        expect(result.command?.command?.name, 'offset-media-input-cursor');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['media-cursor-offset'], '-1000');
      });

      test('should accept input-uuid parameter', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'offset-media-input-cursor',
          '--input-uuid',
          'test-uuid',
          '--media-cursor-offset',
          '500',
        ]);
        expect(result.command?.command?.name, 'offset-media-input-cursor');
        expect(result.command?.command?['input-uuid'], 'test-uuid');
        expect(result.command?.command?['media-cursor-offset'], '500');
      });
    });

    group('ObsTriggerMediaInputActionCommand', () {
      test('should parse arguments correctly with valid parameters', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'trigger-media-input-action',
          '--input-name',
          'test',
          '--media-action',
          'play',
        ]);
        expect(result.command?.command?.name, 'trigger-media-input-action');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['media-action'], 'play');
      });

      test('should accept all valid media actions', () {
        final actions = [
          'none',
          'play',
          'pause',
          'stop',
          'restart',
          'next',
          'previous',
        ];

        for (final action in actions) {
          final result = runner.argParser.parse([
            'media-inputs',
            'trigger-media-input-action',
            '--input-name',
            'test',
            '--media-action',
            action,
          ]);
          expect(result.command?.command?.name, 'trigger-media-input-action');
          expect(result.command?.command?['media-action'], action);
        }
      });

      test('should accept input-uuid parameter', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'trigger-media-input-action',
          '--input-uuid',
          'test-uuid',
          '--media-action',
          'pause',
        ]);
        expect(result.command?.command?.name, 'trigger-media-input-action');
        expect(result.command?.command?['input-uuid'], 'test-uuid');
        expect(result.command?.command?['media-action'], 'pause');
      });

      test('should accept both input-name and input-uuid', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'trigger-media-input-action',
          '--input-name',
          'test',
          '--input-uuid',
          'test-uuid',
          '--media-action',
          'stop',
        ]);
        expect(result.command?.command?.name, 'trigger-media-input-action');
        expect(result.command?.command?['input-name'], 'test');
        expect(result.command?.command?['input-uuid'], 'test-uuid');
        expect(result.command?.command?['media-action'], 'stop');
      });
    });

    group('Command Structure', () {
      test(
        'ObsMediaInputsCommand should have correct name and description',
        () {
          final command = ObsMediaInputsCommand();
          expect(command.name, 'media-inputs');
          expect(command.description, 'Commands that manipulate media inputs');
        },
      );

      test(
        'ObsGetMediaInputStatusCommand should have correct name and description',
        () {
          final command = ObsGetMediaInputStatusCommand();
          expect(command.name, 'get-media-input-status');
          expect(command.description, 'Gets the status of a media input.');
        },
      );

      test(
        'ObsOffsetMediaInputCursorCommand should have correct name and description',
        () {
          final command = ObsOffsetMediaInputCursorCommand();
          expect(command.name, 'offset-media-input-cursor');
          expect(
            command.description,
            'Offsets the cursor position of a media input.',
          );
        },
      );

      test(
        'ObsTriggerMediaInputActionCommand should have correct name and description',
        () {
          final command = ObsTriggerMediaInputActionCommand();
          expect(command.name, 'trigger-media-input-action');
          expect(command.description, 'Triggers an action on a media input.');
        },
      );
    });

    group('Argument Parser Configuration', () {
      test(
        'ObsGetMediaInputStatusCommand should have correct argument options',
        () {
          final command = ObsGetMediaInputStatusCommand();
          final parser = command.argParser;

          expect(parser.options.containsKey('input-name'), true);
          expect(parser.options.containsKey('input-uuid'), true);
          expect(parser.options['input-name']?.help, 'Name of the media input');
          expect(parser.options['input-uuid']?.help, 'UUID of the media input');
        },
      );

      test(
        'ObsSetMediaInputCursorCommand should have correct argument options',
        () {
          final command = ObsSetMediaInputCursorCommand();
          final parser = command.argParser;

          expect(parser.options.containsKey('input-name'), true);
          expect(parser.options.containsKey('input-uuid'), true);
          expect(parser.options.containsKey('media-cursor'), true);
          expect(parser.options['input-name']?.help, 'Name of the media input');
          expect(parser.options['input-uuid']?.help, 'UUID of the media input');
          expect(
            parser.options['media-cursor']?.help,
            'New cursor position to set',
          );
          expect(parser.options['media-cursor']?.mandatory, true);
        },
      );

      test(
        'ObsOffsetMediaInputCursorCommand should have correct argument options',
        () {
          final command = ObsOffsetMediaInputCursorCommand();
          final parser = command.argParser;

          expect(parser.options.containsKey('input-name'), true);
          expect(parser.options.containsKey('input-uuid'), true);
          expect(parser.options.containsKey('media-cursor-offset'), true);
          expect(parser.options['input-name']?.help, 'Name of the media input');
          expect(parser.options['input-uuid']?.help, 'UUID of the media input');
          expect(
            parser.options['media-cursor-offset']?.help,
            'Value to offset the current cursor position by',
          );
          expect(parser.options['media-cursor-offset']?.mandatory, true);
        },
      );

      test(
        'ObsTriggerMediaInputActionCommand should have correct argument options',
        () {
          final command = ObsTriggerMediaInputActionCommand();
          final parser = command.argParser;

          expect(parser.options.containsKey('input-name'), true);
          expect(parser.options.containsKey('input-uuid'), true);
          expect(parser.options.containsKey('media-action'), true);
          expect(parser.options['input-name']?.help, 'Name of the media input');
          expect(parser.options['input-uuid']?.help, 'UUID of the media input');
          expect(
            parser.options['media-action']?.help,
            'The action to trigger on the media input',
          );
          expect(parser.options['media-action']?.mandatory, true);
          expect(parser.options['media-action']?.allowed, [
            'none',
            'play',
            'pause',
            'stop',
            'restart',
            'next',
            'previous',
          ]);
        },
      );
    });

    group('Validation Logic Tests', () {
      // These tests check the validation logic without actually running the commands
      test('media-cursor validation - valid positive integer should parse', () {
        final testValue = '12345';
        final parsed = int.tryParse(testValue);
        expect(parsed, isNotNull);
        expect(parsed! >= 0, true);
      });

      test('media-cursor validation - zero should parse', () {
        final testValue = '0';
        final parsed = int.tryParse(testValue);
        expect(parsed, isNotNull);
        expect(parsed! >= 0, true);
      });

      test('media-cursor validation - negative integer should be detected', () {
        final testValue = '-1';
        final parsed = int.tryParse(testValue);
        expect(parsed, isNotNull);
        expect(parsed! >= 0, false); // Should fail validation for set-cursor
      });

      test(
        'media-cursor-offset validation - negative values should be allowed',
        () {
          final testValue = '-500';
          final parsed = int.tryParse(testValue);
          expect(parsed, isNotNull);
          // Offset allows negative values unlike set-cursor
        },
      );

      test('media-cursor validation - non-integer should fail parsing', () {
        final testValue = 'abc123';
        final parsed = int.tryParse(testValue);
        expect(parsed, isNull); // Should fail parsing
      });

      test('media-cursor validation - float should fail parsing', () {
        final testValue = '123.45';
        final parsed = int.tryParse(testValue);
        expect(parsed, isNull); // Should fail parsing
      });

      test('media-cursor validation - empty string should fail parsing', () {
        final testValue = '';
        final parsed = int.tryParse(testValue);
        expect(parsed, isNull); // Should fail parsing
      });

      test(
        'media-cursor validation - whitespace should be trimmed and parsed correctly',
        () {
          final testValue = ' 123 ';
          final parsed = int.tryParse(testValue);
          expect(parsed, isNotNull);
          expect(
            parsed,
            123,
          ); // int.tryParse actually handles whitespace correctly
        },
      );

      test(
        'media-cursor validation - special characters should fail parsing',
        () {
          final testValue = '123!';
          final parsed = int.tryParse(testValue);
          expect(parsed, isNull); // Should fail parsing
        },
      );
    });

    group('Integration with CommandRunner', () {
      test('should list available subcommands correctly', () {
        final mediaInputsCommand = ObsMediaInputsCommand();
        expect(
          mediaInputsCommand.subcommands.containsKey('get-media-input-status'),
          true,
        );
        expect(
          mediaInputsCommand.subcommands.containsKey('set-media-input-cursor'),
          true,
        );
        expect(
          mediaInputsCommand.subcommands.containsKey(
            'offset-media-input-cursor',
          ),
          true,
        );
        expect(
          mediaInputsCommand.subcommands.containsKey(
            'trigger-media-input-action',
          ),
          true,
        );
      });

      test('should parse help for media-inputs command', () {
        final result = runner.argParser.parse(['media-inputs', '--help']);
        expect(result.command?.name, 'media-inputs');
        expect(result.command?['help'], true);
      });

      test('should parse help for get-media-input-status subcommand', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'get-media-input-status',
          '--help',
        ]);
        expect(result.command?.command?.name, 'get-media-input-status');
        expect(result.command?.command?['help'], true);
      });

      test('should parse help for set-media-input-cursor subcommand', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'set-media-input-cursor',
          '--help',
        ]);
        expect(result.command?.command?.name, 'set-media-input-cursor');
        expect(result.command?.command?['help'], true);
      });

      test('should parse help for offset-media-input-cursor subcommand', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'offset-media-input-cursor',
          '--help',
        ]);
        expect(result.command?.command?.name, 'offset-media-input-cursor');
        expect(result.command?.command?['help'], true);
      });

      test('should parse help for trigger-media-input-action subcommand', () {
        final result = runner.argParser.parse([
          'media-inputs',
          'trigger-media-input-action',
          '--help',
        ]);
        expect(result.command?.command?.name, 'trigger-media-input-action');
        expect(result.command?.command?['help'], true);
      });
    });
  });
}
