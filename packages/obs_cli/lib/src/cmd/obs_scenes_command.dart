import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';

/// Scenes Requests
class ObsScenesCommand extends Command<void> {
  @override
  String get description => 'Scenes Requests';

  @override
  String get name => 'scenes';

  ObsScenesCommand() {
    addSubcommand(ObsGetScenesListCommand());
    addSubcommand(ObsGetGroupListCommand());
    addSubcommand(ObsGetCurrentProgramSceneCommand());
  }
}

class ObsGetScenesListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all scenes in OBS.';

  @override
  String get name => 'get-scenes-list';

  @override
  void run() async {
    await initializeObs();

    final sceneList = await obs.scenes.getSceneList();

    print(sceneList);

    await obs.close();
  }
}

class ObsGetGroupListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all groups in OBS.';

  @override
  String get name => 'get-group-list';

  @override
  void run() async {
    await initializeObs();

    final groupList = await obs.scenes.getGroupList();

    print(groupList);

    await obs.close();
  }
}

class ObsGetCurrentProgramSceneCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the current program scene.';

  @override
  String get name => 'get-current-program-scene';

  @override
  void run() async {
    await initializeObs();

    final currentProgramScene = await obs.scenes.getCurrentProgramScene();

    print(currentProgramScene);

    await obs.close();
  }
}
