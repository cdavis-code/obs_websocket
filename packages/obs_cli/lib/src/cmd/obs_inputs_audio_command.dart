import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_helper_command.dart';
import 'package:obs_websocket/obs_websocket.dart';

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

    await obs.close();
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

    await obs.close();
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

    await obs.close();
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

    await obs.close();
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

    await obs.close();
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
        help: 'Monitor type (none, monitorOnly, monitorAndOutput)',
        mandatory: true,
        allowed: ObsMonitoringType.values.map((e) => e.name).toList(),
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final monitorTypeName = argResults!['monitorType'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final type = ObsMonitoringType.values.byName(monitorTypeName);

    await obs.inputs.setInputAudioMonitorType(
      inputName: inputName,
      inputUuid: inputUuid,
      monitorType: type,
    );

    await obs.close();
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

    await obs.close();
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

    await obs.close();
  }
}
