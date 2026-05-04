import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_helper_command.dart';

/// Gets the items of a list property from an input's properties.
class ObsGetInputPropertiesListPropertyItemsCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets the items of a list property from an input\'s properties.';

  @override
  String get name => 'get-input-properties-list-property-items';

  ObsGetInputPropertiesListPropertyItemsCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'propertyName',
        help: 'Name of the list property to get the items of',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final propertyName = argResults!['propertyName'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final response = await obs.inputs.getInputPropertiesListPropertyItems(
      inputName: inputName,
      inputUuid: inputUuid,
      propertyName: propertyName,
    );

    print(response);

    await obs.close();
  }
}

/// Presses a button in the input's properties.
class ObsPressInputPropertiesButtonCommand extends ObsHelperCommand {
  @override
  String get description => 'Presses a button in the input\'s properties.';

  @override
  String get name => 'press-input-properties-button';

  ObsPressInputPropertiesButtonCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'propertyName',
        help: 'Name of the button property to press',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final propertyName = argResults!['propertyName'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    await obs.inputs.pressInputPropertiesButton(
      inputName: inputName,
      inputUuid: inputUuid,
      propertyName: propertyName,
    );

    await obs.close();
  }
}
