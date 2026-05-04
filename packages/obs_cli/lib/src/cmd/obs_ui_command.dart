import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';
// import 'package:obs_websocket/obs_websocket.dart';

/// UI Requests
class ObsUiCommand extends Command<void> {
  @override
  String get description => 'Commands that manipulate the OBS user interface';

  @override
  String get name => 'ui';

  ObsUiCommand() {
    addSubcommand(ObsGetStudioModeEnabledCommand());
    addSubcommand(ObsSetStudioModeEnabledCommand());
    addSubcommand(ObsGetMonitorListCommand());
  }
}

/// Gets whether studio is enabled.
class ObsGetStudioModeEnabledCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets whether studio is enabled.';

  @override
  String get name => 'get-studio-mode-enabled';

  @override
  void run() async {
    await initializeObs();

    final studioModeEnabled = await obs.ui.getStudioModeEnabled();

    print(studioModeEnabled);

    obs.close();
  }
}

/// Enables or disables studio mode
class ObsSetStudioModeEnabledCommand extends ObsHelperCommand {
  @override
  String get description => 'Enables or disables studio mode.';

  @override
  String get name => 'set-studio-mode-enabled';

  ObsSetStudioModeEnabledCommand() {
    argParser.addFlag('studio-mode', abbr: 'm');
  }

  @override
  void run() async {
    await initializeObs();

    await obs.ui.setStudioModeEnabled(argResults!['studio-mode']);

    obs.close();
  }
}

/// Gets a list of connected monitors and information about them.
class ObsGetMonitorListCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets a list of connected monitors and information about them.';

  @override
  String get name => 'get-monitor-list';

  @override
  void run() async {
    await initializeObs();

    final response = await obs.ui.getMonitorList();

    print(response);

    obs.close();
  }
}
