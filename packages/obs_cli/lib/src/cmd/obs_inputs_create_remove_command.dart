import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_helper_command.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Creates a new input, adding it as a scene item to the specified scene.
class ObsCreateInputCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Creates a new input, adding it as a scene item to the specified scene.';

  @override
  String get name => 'create-input';

  ObsCreateInputCommand() {
    argParser
      ..addOption(
        'sceneName',
        help: 'Name of the scene to add the input to as a scene item',
      )
      ..addOption(
        'sceneUuid',
        help: 'UUID of the scene to add the input to as a scene item',
      )
      ..addOption(
        'inputName',
        help: 'Name of the new input to created',
        mandatory: true,
      )
      ..addOption(
        'inputKind',
        help: 'The kind of input to be created',
        mandatory: true,
      )
      ..addOption(
        'inputSettings',
        help: 'Settings object to initialize the input with',
      )
      ..addOption(
        'sceneItemEnabled',
        help: 'Whether to set the created scene item to enabled or disabled',
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final sceneName = argResults!['sceneName'] as String?;

    final sceneUuid = argResults!['sceneUuid'] as String?;

    final inputName = argResults!['inputName'] as String;

    final inputKind = argResults!['inputKind'] as String;

    final inputSettings = argResults!['inputSettings'] as String?;

    final sceneItemEnabled = argResults!['sceneItemEnabled'] as String?;

    final createInputResponse = await obs.inputs.createInput(
      sceneName: sceneName,
      sceneUuid: sceneUuid,
      inputName: inputName,
      inputKind: inputKind,
      inputSettings: inputSettings != null ? json.decode(inputSettings) : null,
      sceneItemEnabled: sceneItemEnabled?.parseBool(),
    );

    print(createInputResponse);

    await obs.close();
  }
}

/// Removes an existing input.
class ObsRemoveInputCommand extends ObsHelperCommand {
  @override
  String get description => 'Removes an existing input.';

  @override
  String get name => 'remove-input';

  ObsRemoveInputCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input to remove')
      ..addOption('inputUuid', help: 'UUID of the input to remove');
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

    await obs.inputs.removeInput(inputName: inputName, inputUuid: inputUuid);

    await obs.close();
  }
}

/// Gets the default settings for an input kind.
class ObsGetInputDefaultSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the default settings for an input kind.';

  @override
  String get name => 'get-input-default-settings';

  ObsGetInputDefaultSettingsCommand() {
    argParser.addOption(
      'inputKind',
      help: 'Input kind to get the default settings for',
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputKind = argResults!['inputKind'] as String;

    final inputDefaultSettingsResponse = await obs.inputs
        .getInputDefaultSettings(inputKind: inputKind);

    print(inputDefaultSettingsResponse.defaultInputSettings);

    await obs.close();
  }
}

/// Gets the settings of an input.
class ObsGetInputSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the settings of an input.';

  @override
  String get name => 'get-input-settings';

  ObsGetInputSettingsCommand() {
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

    final inputSettingsResponse = await obs.inputs.getInputSettings(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print(inputSettingsResponse);

    await obs.close();
  }
}

/// Sets the settings of an input.
class ObsSetInputSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the settings of an input.';

  @override
  String get name => 'set-input-settings';

  ObsSetInputSettingsCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input to set the settings of')
      ..addOption('inputUuid', help: 'UUID of the input to set the settings of')
      ..addOption(
        'inputSettings',
        help: 'Object of settings to apply',
        mandatory: true,
      )
      ..addOption(
        'overlay',
        help:
            'True == apply the settings on top of existing ones, False == reset the input to its defaults, then apply settings.',
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;

    final inputUuid = argResults!['inputUuid'] as String?;

    final inputSettings = argResults!['inputSettings'] as String;

    final overlay = argResults!['overlay'] as String?;

    await obs.inputs.setInputSettings(
      inputName: inputName,
      inputUuid: inputUuid,
      inputSettings: json.decode(inputSettings),
      overlay: overlay?.parseBool(),
    );

    await obs.close();
  }
}

/// Sets the name of an input (rename).
class ObsSetInputNameCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the name of an input (rename).';

  @override
  String get name => 'set-input-name';

  ObsSetInputNameCommand() {
    argParser
      ..addOption('inputName', help: 'The name of the input to rename')
      ..addOption('inputUuid', help: 'Current input UUID')
      ..addOption('newInputName', help: 'New name for the input');
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;

    final inputUuid = argResults!['inputUuid'] as String?;

    final newInputName = argResults!['newInputName'] as String;

    await obs.inputs.setInputName(
      inputName: inputName,
      inputUuid: inputUuid,
      newInputName: newInputName,
    );

    await obs.close();
  }
}
