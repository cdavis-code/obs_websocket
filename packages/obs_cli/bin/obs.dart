import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';
import 'package:obs_websocket/obs_websocket.dart' show Validate;
import 'package:universal_io/io.dart';

void main(List<String> arguments) async {
  await (CommandRunner<void>(
          'obs',
          'A command line interface for controlling OBS.',
        )
        ..argParser.addOption(
          'uri',
          abbr: 'u',
          valueHelp: 'ws://[host]:[port]',
          help: 'The url and port for OBS websocket',
        )
        ..argParser.addOption(
          'timeout',
          abbr: 't',
          valueHelp: 'int',
          help: 'The timeout in seconds for the web socket connection.',
          callback: (value) =>
              Validate.isNull(value) || Validate.isGreaterOrEqual(value, 1),
        )
        ..argParser.addOption(
          'log-level',
          abbr: 'l',
          allowed: ['all', 'debug', 'info', 'warning', 'error', 'off'],
          defaultsTo: 'off',
        )
        ..argParser.addOption(
          'passwd',
          abbr: 'p',
          valueHelp: 'string',
          help: 'The OBS websocket password, only required if enabled in OBS',
        )
        ..addCommand(ObsAuthorizeCommand())
        ..addCommand(ObsInputsCommand())
        ..addCommand(ObsListenCommand())
        ..addCommand(ObsGeneralCommand())
        ..addCommand(ObsConfigCommand())
        ..addCommand(ObsMediaInputsCommand())
        ..addCommand(ObsSendCommand())
        ..addCommand(ObsSourcesCommand())
        // ..addCommand(ObsProfilesCommand())
        // ..addCommand(ObsRecordingCommand())
        ..addCommand(ObsSceneItemsCommand())
        ..addCommand(ObsScenesCommand())
        ..addCommand(ObsStreamCommand())
        ..addCommand(ObsUiCommand())
        ..addCommand(ObsVersionCommand()))
      .run(arguments)
      .catchError((Object error) {
        if (error is! UsageException) throw error;

        print(error);

        exit(64); // Exit code 64 indicates a usage error.
      });
}
