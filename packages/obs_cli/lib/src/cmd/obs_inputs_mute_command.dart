import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_helper_command.dart';

/// Gets the mute status of an input.
class ObsGetInputMuteCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the mute status of an input.';

  @override
  String get name => 'get-input-mute';

  ObsGetInputMuteCommand() {
    argParser.addOption(
      'inputName',
      help: 'The name of the input to get the mute status of.',
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String;

    final muted = await obs.inputs.getInputMute(inputName);

    print(muted);

    await obs.close();
  }
}

/// Sets the mute status of an input.
class ObsSetInputMuteCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the mute status of an input.';

  @override
  String get name => 'set-input-mute';

  ObsSetInputMuteCommand() {
    argParser
      ..addOption(
        'inputName',
        help: 'The name of the input to set the mute status of.',
      )
      ..addOption(
        'inputUuid',
        help: 'The UUID of the input to set the mute status of.',
      )
      ..addFlag('mute', help: 'Whether to mute the input.');
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;

    final inputUuid = argResults!['inputUuid'] as String?;

    final inputMuted = argResults!['mute'] as bool;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    await obs.inputs.setInputMute(
      inputName: inputName,
      inputUuid: inputUuid,
      inputMuted: inputMuted,
    );

    await obs.close();
  }
}

/// Toggles the mute status of an input.
class ObsToggleInputMuteCommand extends ObsHelperCommand {
  @override
  String get description => 'Toggles the mute status of an input.';

  @override
  String get name => 'toggle-input-mute';

  ObsToggleInputMuteCommand() {
    argParser
      ..addOption(
        'inputName',
        help: 'Name of the input to toggle the mute state of',
      )
      ..addOption(
        'inputUuid',
        help: 'UUID of the input to toggle the mute state of',
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;

    final inputUuid = argResults!['inputUuid'] as String?;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final muted = await obs.inputs.toggleInputMute(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print(muted);

    await obs.close();
  }
}
