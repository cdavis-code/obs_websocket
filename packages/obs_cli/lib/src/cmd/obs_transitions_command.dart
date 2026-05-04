import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';

/// Transitions Requests
class ObsTransitionsCommand extends Command<void> {
  @override
  String get description => 'Transitions Requests';

  @override
  String get name => 'transitions';

  ObsTransitionsCommand() {
    addSubcommand(ObsGetTransitionKindListCommand());
    addSubcommand(ObsGetSceneTransitionListCommand());
    addSubcommand(ObsGetCurrentSceneTransitionCommand());
    addSubcommand(ObsSetCurrentSceneTransitionCommand());
    addSubcommand(ObsSetCurrentSceneTransitionDurationCommand());
    addSubcommand(ObsGetCurrentSceneTransitionCursorCommand());
    addSubcommand(ObsTriggerStudioModeTransitionCommand());
    addSubcommand(ObsSetTBarPositionCommand());
  }
}

/// Gets an array of all available transition kinds.
class ObsGetTransitionKindListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all available transition kinds.';

  @override
  String get name => 'get-transition-kind-list';

  @override
  Future<void> run() async {
    await initializeObs();

    final kinds = await obs.transitions.getTransitionKindList();

    print(kinds);

    await obs.close();
  }
}

/// Gets an array of all scene transitions in OBS.
class ObsGetSceneTransitionListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all scene transitions in OBS.';

  @override
  String get name => 'get-scene-transition-list';

  @override
  Future<void> run() async {
    await initializeObs();

    final transitions = await obs.transitions.getSceneTransitionList();

    print(transitions);

    await obs.close();
  }
}

/// Gets information about the current scene transition.
class ObsGetCurrentSceneTransitionCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets information about the current scene transition.';

  @override
  String get name => 'get-current-scene-transition';

  @override
  Future<void> run() async {
    await initializeObs();

    final transition = await obs.transitions.getCurrentSceneTransition();

    print(transition);

    await obs.close();
  }
}

/// Sets the current scene transition.
class ObsSetCurrentSceneTransitionCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the current scene transition.';

  @override
  String get name => 'set-current-scene-transition';

  ObsSetCurrentSceneTransitionCommand() {
    argParser.addOption(
      'transitionName',
      help: 'Name of the transition to set as current',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final transitionName = argResults!['transitionName'] as String;

    await obs.transitions.setCurrentSceneTransition(transitionName);

    print('Transition set: $transitionName');

    await obs.close();
  }
}

/// Sets the duration of the current scene transition.
class ObsSetCurrentSceneTransitionDurationCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Sets the duration of the current scene transition.';

  @override
  String get name => 'set-current-scene-transition-duration';

  ObsSetCurrentSceneTransitionDurationCommand() {
    argParser.addOption(
      'transitionDuration',
      help: 'Duration in milliseconds',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final duration = int.parse(argResults!['transitionDuration'] as String);

    await obs.transitions.setCurrentSceneTransitionDuration(duration);

    print('Transition duration set: ${duration}ms');

    await obs.close();
  }
}

/// Gets the cursor position of the current scene transition.
class ObsGetCurrentSceneTransitionCursorCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets the cursor position of the current scene transition.';

  @override
  String get name => 'get-current-scene-transition-cursor';

  @override
  Future<void> run() async {
    await initializeObs();

    final cursor = await obs.transitions.getCurrentSceneTransitionCursor();

    print('transitionCursor: $cursor');

    await obs.close();
  }
}

/// Triggers the current scene transition.
class ObsTriggerStudioModeTransitionCommand extends ObsHelperCommand {
  @override
  String get description => 'Triggers the current scene transition.';

  @override
  String get name => 'trigger-studio-mode-transition';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.transitions.triggerStudioModeTransition();

    print('Studio mode transition triggered');

    await obs.close();
  }
}

/// Sets the position of the T-Bar.
class ObsSetTBarPositionCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the position of the T-Bar.';

  @override
  String get name => 'set-t-bar-position';

  ObsSetTBarPositionCommand() {
    argParser.addOption(
      'position',
      help: 'Position (0.0 to 1.0)',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final position = double.parse(argResults!['position'] as String);

    await obs.transitions.setTBarPosition(position: position);

    print('T-Bar position set: $position');

    await obs.close();
  }
}
