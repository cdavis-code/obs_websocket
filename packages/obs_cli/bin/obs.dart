import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';
import 'package:obs_websocket/obs_websocket.dart'
    show
        ObsException,
        ObsArgumentException,
        ObsAuthenticationException,
        Validate;
import 'package:universal_io/io.dart';

/// BSD/sysexits.h-inspired exit codes used by the CLI.
///
/// * `64` - command-line usage error
/// * `69` - OBS service unavailable (connection refused/timeout)
/// * `70` - internal software error (unknown throw)
/// * `77` - permission denied (auth failure)
const _exitUsage = 64;
const _exitUnavailable = 69;
const _exitSoftware = 70;
const _exitNoPerm = 77;

void main(List<String> arguments) {
  runZonedGuarded<Future<void>>(
    () async {
      await _buildRunner().run(arguments);
    },
    (error, stack) {
      _handleFatalError(error, stack);
    },
  );
}

CommandRunner<void> _buildRunner() {
  return CommandRunner<void>(
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
    ..addCommand(ObsFiltersCommand())
    ..addCommand(ObsInputsCommand())
    ..addCommand(ObsListenCommand())
    ..addCommand(ObsGeneralCommand())
    ..addCommand(ObsConfigCommand())
    ..addCommand(ObsMediaInputsCommand())
    ..addCommand(ObsOutputsCommand())
    ..addCommand(ObsRecordCommand())
    ..addCommand(ObsSendCommand())
    ..addCommand(ObsSourcesCommand())
    // ..addCommand(ObsProfilesCommand())
    // ..addCommand(ObsRecordingCommand())
    ..addCommand(ObsSceneItemsCommand())
    ..addCommand(ObsScenesCommand())
    ..addCommand(ObsStreamCommand())
    ..addCommand(ObsTransitionsCommand())
    ..addCommand(ObsUiCommand())
    ..addCommand(ObsVersionCommand());
}

/// Maps a thrown [error] to a sysexits-compatible exit code and writes a
/// short, user-friendly message to stderr.
void _handleFatalError(Object error, StackTrace stack) {
  if (error is UsageException) {
    stderr.writeln(error);
    exit(_exitUsage);
  }
  if (error is ObsArgumentException) {
    stderr.writeln(error.message);
    exit(_exitUsage);
  }
  if (error is ObsAuthenticationException) {
    stderr.writeln('Authentication failed: ${error.message}');
    exit(_exitNoPerm);
  }
  if (error is ObsException) {
    stderr.writeln('OBS error: ${error.message}');
    exit(_exitUnavailable);
  }
  // Unknown error — surface full details to help triage.
  stderr.writeln('Unexpected error: $error');
  stderr.writeln(stack);
  exit(_exitSoftware);
}
