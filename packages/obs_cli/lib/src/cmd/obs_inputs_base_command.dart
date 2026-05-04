import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_inputs_audio_command.dart';
import 'package:obs_cli/src/cmd/obs_inputs_create_remove_command.dart';
import 'package:obs_cli/src/cmd/obs_inputs_deinterlace_command.dart';
import 'package:obs_cli/src/cmd/obs_inputs_list_command.dart';
import 'package:obs_cli/src/cmd/obs_inputs_mute_command.dart';
import 'package:obs_cli/src/cmd/obs_inputs_properties_command.dart';
import 'package:obs_cli/src/cmd/obs_inputs_volume_command.dart';

/// Inputs Requests - Parent command that groups all input-related subcommands.
class ObsInputsCommand extends Command<void> {
  @override
  String get description => 'Inputs Requests';

  @override
  String get name => 'inputs';

  ObsInputsCommand() {
    // List commands
    addSubcommand(ObsGetInputListCommand());
    addSubcommand(ObsGetInputKindListCommand());
    addSubcommand(ObsGetSpecialInputsCommand());

    // Create/Remove/Settings commands
    addSubcommand(ObsCreateInputCommand());
    addSubcommand(ObsRemoveInputCommand());
    addSubcommand(ObsSetInputNameCommand());
    addSubcommand(ObsGetInputDefaultSettingsCommand());
    addSubcommand(ObsGetInputSettingsCommand());
    addSubcommand(ObsSetInputSettingsCommand());

    // Mute commands
    addSubcommand(ObsGetInputMuteCommand());
    addSubcommand(ObsSetInputMuteCommand());
    addSubcommand(ObsToggleInputMuteCommand());

    // Volume commands
    addSubcommand(ObsGetInputVolumeCommand());
    addSubcommand(ObsSetInputVolumeCommand());

    // Deinterlace commands
    addSubcommand(ObsGetInputDeinterlaceModeCommand());
    addSubcommand(ObsSetInputDeinterlaceModeCommand());
    addSubcommand(ObsGetInputDeinterlaceFieldOrderCommand());
    addSubcommand(ObsSetInputDeinterlaceFieldOrderCommand());

    // Audio commands
    addSubcommand(ObsGetInputAudioBalanceCommand());
    addSubcommand(ObsSetInputAudioBalanceCommand());
    addSubcommand(ObsGetInputAudioSyncOffsetCommand());
    addSubcommand(ObsSetInputAudioSyncOffsetCommand());
    addSubcommand(ObsGetInputAudioMonitorTypeCommand());
    addSubcommand(ObsSetInputAudioMonitorTypeCommand());
    addSubcommand(ObsGetInputAudioTracksCommand());
    addSubcommand(ObsSetInputAudioTracksCommand());

    // Properties commands
    addSubcommand(ObsGetInputPropertiesListPropertyItemsCommand());
    addSubcommand(ObsPressInputPropertiesButtonCommand());
  }
}
