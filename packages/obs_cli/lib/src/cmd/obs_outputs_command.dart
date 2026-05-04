import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';

/// Outputs Requests
class ObsOutputsCommand extends Command<void> {
  @override
  String get description => 'Outputs Requests';

  @override
  String get name => 'outputs';

  ObsOutputsCommand() {
    addSubcommand(ObsGetVirtualCamStatusCommand());
    addSubcommand(ObsToggleVirtualCamCommand());
    addSubcommand(ObsStartVirtualCamCommand());
    addSubcommand(ObsStopVirtualCamCommand());
    addSubcommand(ObsGetReplayBufferStatusCommand());
    addSubcommand(ObsToggleReplayBufferCommand());
    addSubcommand(ObsStartReplayBufferCommand());
    addSubcommand(ObsStopReplayBufferCommand());
    addSubcommand(ObsSaveReplayBufferCommand());
    addSubcommand(ObsGetOutputListCommand());
    addSubcommand(ObsGetOutputStatusCommand());
    addSubcommand(ObsToggleOutputCommand());
    addSubcommand(ObsStartOutputCommand());
    addSubcommand(ObsStopOutputCommand());
    addSubcommand(ObsGetOutputSettingsCommand());
    addSubcommand(ObsSetOutputSettingsCommand());
  }
}

/// Gets the status of the virtualcam output.
class ObsGetVirtualCamStatusCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the status of the virtualcam output.';

  @override
  String get name => 'get-virtual-cam-status';

  @override
  Future<void> run() async {
    await initializeObs();

    final status = await obs.outputs.getVirtualCamStatus();

    print('outputActive: $status');

    await obs.close();
  }
}

/// Toggles the state of the virtualcam output.
class ObsToggleVirtualCamCommand extends ObsHelperCommand {
  @override
  String get description => 'Toggles the state of the virtualcam output.';

  @override
  String get name => 'toggle-virtual-cam';

  @override
  Future<void> run() async {
    await initializeObs();

    final status = await obs.outputs.toggleVirtualCam();

    print('outputActive: $status');

    await obs.close();
  }
}

/// Starts the virtualcam output.
class ObsStartVirtualCamCommand extends ObsHelperCommand {
  @override
  String get description => 'Starts the virtualcam output.';

  @override
  String get name => 'start-virtual-cam';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.outputs.startVirtualCam();

    print('VirtualCam started');

    await obs.close();
  }
}

/// Stops the virtualcam output.
class ObsStopVirtualCamCommand extends ObsHelperCommand {
  @override
  String get description => 'Stops the virtualcam output.';

  @override
  String get name => 'stop-virtual-cam';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.outputs.stopVirtualCam();

    print('VirtualCam stopped');

    await obs.close();
  }
}

/// Gets the status of the replay buffer output.
class ObsGetReplayBufferStatusCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the status of the replay buffer output.';

  @override
  String get name => 'get-replay-buffer-status';

  @override
  Future<void> run() async {
    await initializeObs();

    final status = await obs.outputs.getReplayBufferStatus();

    print('outputActive: $status');

    await obs.close();
  }
}

/// Toggles the state of the replay buffer output.
class ObsToggleReplayBufferCommand extends ObsHelperCommand {
  @override
  String get description => 'Toggles the state of the replay buffer output.';

  @override
  String get name => 'toggle-replay-buffer';

  @override
  Future<void> run() async {
    await initializeObs();

    final status = await obs.outputs.toggleReplayBuffer();

    print('outputActive: $status');

    await obs.close();
  }
}

/// Starts the replay buffer output.
class ObsStartReplayBufferCommand extends ObsHelperCommand {
  @override
  String get description => 'Starts the replay buffer output.';

  @override
  String get name => 'start-replay-buffer';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.outputs.startReplayBuffer('');

    print('ReplayBuffer started');

    await obs.close();
  }
}

/// Stops the replay buffer output.
class ObsStopReplayBufferCommand extends ObsHelperCommand {
  @override
  String get description => 'Stops the replay buffer output.';

  @override
  String get name => 'stop-replay-buffer';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.outputs.stopReplayBuffer('');

    print('ReplayBuffer stopped');

    await obs.close();
  }
}

/// Saves the contents of the replay buffer output.
class ObsSaveReplayBufferCommand extends ObsHelperCommand {
  @override
  String get description => 'Saves the contents of the replay buffer output.';

  @override
  String get name => 'save-replay-buffer';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.outputs.saveReplayBuffer('');

    print('ReplayBuffer saved');

    await obs.close();
  }
}

/// Gets the list of available outputs.
class ObsGetOutputListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the list of available outputs.';

  @override
  String get name => 'get-output-list';

  @override
  Future<void> run() async {
    await initializeObs();

    final outputs = await obs.outputs.getOutputList();

    print(outputs);

    await obs.close();
  }
}

/// Gets the status of an output.
class ObsGetOutputStatusCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the status of an output.';

  @override
  String get name => 'get-output-status';

  ObsGetOutputStatusCommand() {
    argParser.addOption(
      'outputName',
      help: 'Name of the output',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final outputName = argResults!['outputName'] as String;

    final status = await obs.outputs.getOutputStatus(outputName);

    print(status);

    await obs.close();
  }
}

/// Toggles the status of an output.
class ObsToggleOutputCommand extends ObsHelperCommand {
  @override
  String get description => 'Toggles the status of an output.';

  @override
  String get name => 'toggle-output';

  ObsToggleOutputCommand() {
    argParser.addOption(
      'outputName',
      help: 'Name of the output',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final outputName = argResults!['outputName'] as String;

    final status = await obs.outputs.toggleOutput(outputName);

    print('outputActive: $status');

    await obs.close();
  }
}

/// Starts an output.
class ObsStartOutputCommand extends ObsHelperCommand {
  @override
  String get description => 'Starts an output.';

  @override
  String get name => 'start-output';

  ObsStartOutputCommand() {
    argParser.addOption(
      'outputName',
      help: 'Name of the output',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final outputName = argResults!['outputName'] as String;

    await obs.outputs.startOutput(outputName);

    print('Output started: $outputName');

    await obs.close();
  }
}

/// Stops an output.
class ObsStopOutputCommand extends ObsHelperCommand {
  @override
  String get description => 'Stops an output.';

  @override
  String get name => 'stop-output';

  ObsStopOutputCommand() {
    argParser.addOption(
      'outputName',
      help: 'Name of the output',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final outputName = argResults!['outputName'] as String;

    await obs.outputs.stopOutput(outputName);

    print('Output stopped: $outputName');

    await obs.close();
  }
}

/// Gets the settings of an output.
class ObsGetOutputSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the settings of an output.';

  @override
  String get name => 'get-output-settings';

  ObsGetOutputSettingsCommand() {
    argParser.addOption(
      'outputName',
      help: 'Name of the output',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final outputName = argResults!['outputName'] as String;

    final settings = await obs.outputs.getOutputSettings(outputName);

    print(settings);

    await obs.close();
  }
}

/// Sets the settings of an output.
class ObsSetOutputSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the settings of an output.';

  @override
  String get name => 'set-output-settings';

  ObsSetOutputSettingsCommand() {
    argParser
      ..addOption('outputName', help: 'Name of the output', mandatory: true)
      ..addOption(
        'outputSettings',
        help: 'Settings object to apply (JSON)',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final outputName = argResults!['outputName'] as String;
    final outputSettings = argResults!['outputSettings'] as String;

    await obs.outputs.setOutputSettings(
      outputName: outputName,
      outputSettings: json.decode(outputSettings),
    );

    await obs.close();
  }
}
