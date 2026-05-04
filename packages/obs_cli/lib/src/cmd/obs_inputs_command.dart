import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Config Requests
class ObsInputsCommand extends Command<void> {
  @override
  String get description => 'Inputs Requests';

  @override
  String get name => 'inputs';

  ObsInputsCommand() {
    addSubcommand(ObsGetInputListCommand());
    addSubcommand(ObsGetInputKindListCommand());
    addSubcommand(ObsGetSpecialInputsCommand());
    addSubcommand(ObsCreateInputCommand());
    addSubcommand(ObsRemoveInputCommand());
    addSubcommand(ObsSetInputNameCommand());
    addSubcommand(ObsGetInputMuteCommand());
    addSubcommand(ObsSetInputMuteCommand());
    addSubcommand(ObsGetInputDefaultSettingsCommand());
    addSubcommand(ObsGetInputSettingsCommand());
    addSubcommand(ObsSetInputSettingsCommand());
    addSubcommand(ObsToggleInputMuteCommand());
    addSubcommand(ObsGetInputVolumeCommand());
    addSubcommand(ObsSetInputVolumeCommand());
    addSubcommand(ObsGetInputDeinterlaceModeCommand());
    addSubcommand(ObsSetInputDeinterlaceModeCommand());
    addSubcommand(ObsGetInputDeinterlaceFieldOrderCommand());
    addSubcommand(ObsSetInputDeinterlaceFieldOrderCommand());
    addSubcommand(ObsGetInputAudioBalanceCommand());
    addSubcommand(ObsSetInputAudioBalanceCommand());
    addSubcommand(ObsGetInputAudioSyncOffsetCommand());
    addSubcommand(ObsSetInputAudioSyncOffsetCommand());
    addSubcommand(ObsGetInputAudioMonitorTypeCommand());
    addSubcommand(ObsSetInputAudioMonitorTypeCommand());
    addSubcommand(ObsGetInputAudioTracksCommand());
    addSubcommand(ObsSetInputAudioTracksCommand());
    addSubcommand(ObsGetInputPropertiesListPropertyItemsCommand());
    addSubcommand(ObsPressInputPropertiesButtonCommand());
  }
}

/// Gets an array of all inputs in OBS.
class ObsGetInputListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all inputs in OBS.';

  @override
  String get name => 'get-input-list';

  ObsGetInputListCommand() {
    argParser.addOption('inputKind', help: 'The kind of input to get.');
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputKind = argResults!['inputKind'] as String?;

    final inputs = await obs.inputs.getInputList(inputKind);

    print(inputs);

    obs.close();
  }
}

/// Gets an array of all available input kinds in OBS.
class ObsGetInputKindListCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets an array of all available input kinds in OBS.';

  @override
  String get name => 'get-input-kind-list';

  ObsGetInputKindListCommand() {
    argParser.addFlag(
      'unversioned',
      help: 'Whether to get unversioned input kinds.',
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final unversioned = argResults!['unversioned'] as bool;

    final inputKinds = await obs.inputs.getInputKindList(unversioned);

    print(inputKinds);

    obs.close();
  }
}

/// Gets the names of all special inputs.
class ObsGetSpecialInputsCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the names of all special inputs.';

  @override
  String get name => 'get-special-inputs';

  @override
  Future<void> run() async {
    await initializeObs();

    final specialInputsResponse = await obs.inputs.getSpecialInputs();

    print(specialInputsResponse);

    obs.close();
  }
}

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

    obs.close();
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
      ..addOption('inputName', help: '	Name of the input to remove')
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

    obs.close();
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

    obs.close();
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

    obs.close();
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
      ..addOption(
        'inputName',
        help: 'Input kind to get the default settings for',
      )
      ..addOption(
        'inputUuid',
        help: 'Input kind to get the default settings for',
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

    final inputSettingsResponse = await obs.inputs.getInputSettings(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print(inputSettingsResponse);

    obs.close();
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

    obs.close();
  }
}

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

    obs.close();
  }
}

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

    obs.close();
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

    obs.close();
  }
}

/// Gets the deinterlace mode of an input.
class ObsGetInputDeinterlaceModeCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the deinterlace mode of an input.';

  @override
  String get name => 'get-input-deinterlace-mode';

  ObsGetInputDeinterlaceModeCommand() {
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

    final response = await obs.inputs.getInputDeinterlaceMode(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print('deinterlaceMode: ${response.deinterlaceMode}');

    obs.close();
  }
}

/// Sets the deinterlace mode of an input.
class ObsSetInputDeinterlaceModeCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the deinterlace mode of an input.';

  @override
  String get name => 'set-input-deinterlace-mode';

  ObsSetInputDeinterlaceModeCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'deinterlaceMode',
        help:
            'Deinterlace mode (none, discard, retro, blend, adaptive, linear)',
        mandatory: true,
        allowed: ['none', 'discard', 'retro', 'blend', 'adaptive', 'linear'],
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final deinterlaceMode = argResults!['deinterlaceMode'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final mode = ObsDeinterlaceMode.values.firstWhere(
      (e) => e.code == deinterlaceMode,
    );

    await obs.inputs.setInputDeinterlaceMode(
      inputName: inputName,
      inputUuid: inputUuid,
      deinterlaceMode: mode,
    );

    obs.close();
  }
}

/// Gets the deinterlace field order of an input.
class ObsGetInputDeinterlaceFieldOrderCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the deinterlace field order of an input.';

  @override
  String get name => 'get-input-deinterlace-field-order';

  ObsGetInputDeinterlaceFieldOrderCommand() {
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

    final response = await obs.inputs.getInputDeinterlaceFieldOrder(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print('deinterlaceFieldOrder: ${response.deinterlaceFieldOrder}');

    obs.close();
  }
}

/// Sets the deinterlace field order of an input.
class ObsSetInputDeinterlaceFieldOrderCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the deinterlace field order of an input.';

  @override
  String get name => 'set-input-deinterlace-field-order';

  ObsSetInputDeinterlaceFieldOrderCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'deinterlaceFieldOrder',
        help: 'Field order (top, bottom)',
        mandatory: true,
        allowed: ['top', 'bottom'],
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final fieldOrder = argResults!['deinterlaceFieldOrder'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final order = ObsDeinterlaceFieldOrder.values.firstWhere(
      (e) => e.code == fieldOrder,
    );

    await obs.inputs.setInputDeinterlaceFieldOrder(
      inputName: inputName,
      inputUuid: inputUuid,
      deinterlaceFieldOrder: order,
    );

    obs.close();
  }
}

/// Gets the audio balance of an input.
class ObsGetInputAudioBalanceCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the audio balance of an input.';

  @override
  String get name => 'get-input-audio-balance';

  ObsGetInputAudioBalanceCommand() {
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

    final response = await obs.inputs.getInputAudioBalance(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print('inputAudioBalance: ${response.inputAudioBalance}');

    obs.close();
  }
}

/// Sets the audio balance of an input.
class ObsSetInputAudioBalanceCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the audio balance of an input.';

  @override
  String get name => 'set-input-audio-balance';

  ObsSetInputAudioBalanceCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'inputAudioBalance',
        help: 'Audio balance (0.0 = left, 1.0 = right)',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final inputAudioBalance = double.parse(
      argResults!['inputAudioBalance'] as String,
    );

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    await obs.inputs.setInputAudioBalance(
      inputName: inputName,
      inputUuid: inputUuid,
      inputAudioBalance: inputAudioBalance,
    );

    obs.close();
  }
}

/// Gets the audio sync offset of an input.
class ObsGetInputAudioSyncOffsetCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the audio sync offset of an input.';

  @override
  String get name => 'get-input-audio-sync-offset';

  ObsGetInputAudioSyncOffsetCommand() {
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

    final response = await obs.inputs.getInputAudioSyncOffset(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print('inputAudioSyncOffset: ${response.inputAudioSyncOffset} ms');

    obs.close();
  }
}

/// Sets the audio sync offset of an input.
class ObsSetInputAudioSyncOffsetCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the audio sync offset of an input.';

  @override
  String get name => 'set-input-audio-sync-offset';

  ObsSetInputAudioSyncOffsetCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'inputAudioSyncOffset',
        help: 'Audio sync offset in milliseconds',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final inputAudioSyncOffset = int.parse(
      argResults!['inputAudioSyncOffset'] as String,
    );

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    await obs.inputs.setInputAudioSyncOffset(
      inputName: inputName,
      inputUuid: inputUuid,
      inputAudioSyncOffset: inputAudioSyncOffset,
    );

    obs.close();
  }
}

/// Gets the audio monitor type of an input.
class ObsGetInputAudioMonitorTypeCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the audio monitor type of an input.';

  @override
  String get name => 'get-input-audio-monitor-type';

  ObsGetInputAudioMonitorTypeCommand() {
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

    final response = await obs.inputs.getInputAudioMonitorType(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print('monitorType: ${response.monitorType}');

    obs.close();
  }
}

/// Sets the audio monitor type of an input.
class ObsSetInputAudioMonitorTypeCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the audio monitor type of an input.';

  @override
  String get name => 'set-input-audio-monitor-type';

  ObsSetInputAudioMonitorTypeCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'monitorType',
        help: 'Monitor type (none, monitorOnly, monitorAndOutput, outputOnly)',
        mandatory: true,
        allowed: ['none', 'monitorOnly', 'monitorAndOutput', 'outputOnly'],
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final monitorType = argResults!['monitorType'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final type = ObsMonitoringType.values.firstWhere(
      (e) => e.code == monitorType,
    );

    await obs.inputs.setInputAudioMonitorType(
      inputName: inputName,
      inputUuid: inputUuid,
      monitorType: type,
    );

    obs.close();
  }
}

/// Gets the audio tracks of an input.
class ObsGetInputAudioTracksCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the audio tracks of an input.';

  @override
  String get name => 'get-input-audio-tracks';

  ObsGetInputAudioTracksCommand() {
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

    final response = await obs.inputs.getInputAudioTracks(
      inputName: inputName,
      inputUuid: inputUuid,
    );

    print('inputAudioTracks: ${response.inputAudioTracks}');

    obs.close();
  }
}

/// Sets the audio tracks of an input.
class ObsSetInputAudioTracksCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the audio tracks of an input.';

  @override
  String get name => 'set-input-audio-tracks';

  ObsSetInputAudioTracksCommand() {
    argParser
      ..addOption('inputName', help: 'Name of the input')
      ..addOption('inputUuid', help: 'UUID of the input')
      ..addOption(
        'inputAudioTracks',
        help: 'Audio tracks bitmask (e.g., 63 for all 6 tracks)',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final inputAudioTracks = int.parse(
      argResults!['inputAudioTracks'] as String,
    );

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    await obs.inputs.setInputAudioTracks(
      inputName: inputName,
      inputUuid: inputUuid,
      inputAudioTracks: inputAudioTracks,
    );

    obs.close();
  }
}

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

    obs.close();
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

    obs.close();
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
        help: 'The name of the input to set the mute status of.',
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

    obs.close();
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

    obs.close();
  }
}
