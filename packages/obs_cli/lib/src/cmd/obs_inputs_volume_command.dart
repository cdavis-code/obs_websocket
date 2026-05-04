import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_helper_command.dart';

/// Gets the current volume setting of an input.
class ObsGetInputVolumeCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the current volume setting of an input.';

  @override
  String get name => 'get-input-volume';

  ObsGetInputVolumeCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input');
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

    final volumeResponse = await obs.inputs.getInputVolume(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print(
      'inputVolumeMul: ${volumeResponse.inputVolumeMul}, inputVolumeDb: ${volumeResponse.inputVolumeDb}',
    );

    await obs.close();
  }
}

/// Sets the volume of an input.
class ObsSetInputVolumeCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the volume of an input.';

  @override
  String get name => 'set-input-volume';

  ObsSetInputVolumeCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'inputVolume',
        help: 'Volume in mul (0.0 to 1.0)',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final inputVolume = double.parse(argResults!['inputVolume'] as String);

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    await obs.inputs.setInputVolume(
      inputName: inputName,
      inputUuid: inputUuid,
      inputVolume: inputVolume,
    );

    await obs.close();
  }
}
