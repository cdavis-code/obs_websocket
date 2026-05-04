import 'package:args/command_runner.dart';
import 'package:obs_cli/obs_cli.dart';

/// SceneItem Requests
class ObsSceneItemsCommand extends Command<void> {
  @override
  String get description => 'Scene Items Requests';

  @override
  String get name => 'scene-items';

  ObsSceneItemsCommand() {
    addSubcommand(ObsGetSceneItemListCommand());
    addSubcommand(ObsGetSceneItemLockedCommand());
    addSubcommand(ObsSetSceneItemLockedCommand());
  }
}

/// Gets a list of all scene items in a scene.
class ObsGetSceneItemListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the lock state of a scene item.';

  @override
  String get name => 'get-scene-item-list';

  ObsGetSceneItemListCommand() {
    argParser.addOption(
      'scene-name',
      abbr: 'n',
      mandatory: true,
      valueHelp: 'string',
      help: 'Name of the scene to get the items of',
    );
  }

  @override
  void run() async {
    await initializeObs();

    final sceneItemDetailList = await obs.sceneItems.getSceneItemList(
      argResults!['scene-name'],
    );

    print(sceneItemDetailList);

    await obs.close();
  }
}

/// Gets the lock state of a scene item.
class ObsGetSceneItemLockedCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the lock state of a scene item.';

  @override
  String get name => 'get-scene-item-locked';

  ObsGetSceneItemLockedCommand() {
    argParser
      ..addOption(
        'scene-name',
        abbr: 'n',
        mandatory: true,
        valueHelp: 'string',
        help: 'Name of the scene the item is in',
      )
      ..addOption(
        'scene-item-id',
        abbr: 'i',
        mandatory: true,
        valueHelp: 'int',
        help: 'Numeric ID of the scene item',
      );
  }

  @override
  void run() async {
    await initializeObs();

    final isLocked = await obs.sceneItems.getLocked(
      sceneName: argResults!['scene-name'],
      sceneItemId: int.parse(argResults!['scene-item-id']),
    );

    print(isLocked);

    await obs.close();
  }
}

/// Sets the lock state of a scene item.
class ObsSetSceneItemLockedCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the lock state of a scene item.';

  @override
  String get name => 'set-scene-item-locked';

  ObsSetSceneItemLockedCommand() {
    argParser
      ..addOption(
        'scene-name',
        abbr: 'n',
        mandatory: true,
        valueHelp: 'string',
        help: 'Name of the scene the item is in',
      )
      ..addOption(
        'scene-item-id',
        abbr: 'i',
        mandatory: true,
        valueHelp: 'int',
        help: 'Numeric ID of the scene item',
      )
      ..addFlag(
        'scene-item-locked',
        abbr: 'l',
        help: 'New lock state of the scene item',
      );
  }

  @override
  void run() async {
    await initializeObs();

    await obs.sceneItems.setLocked(
      sceneName: argResults!['scene-name'],
      sceneItemId: int.parse(argResults!['scene-item-id']),
      sceneItemLocked: argResults!['scene-item-locked'],
    );

    await obs.close();
  }
}
