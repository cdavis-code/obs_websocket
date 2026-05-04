import 'package:args/command_runner.dart';
import 'package:obs_cli/src/cmd/obs_helper_command.dart';
import 'package:obs_websocket/obs_websocket.dart';

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

    await obs.close();
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
            'Deinterlace mode (disable, discard, retro, blend, blend2x, linear, linear2x, yadif, yadif2x)',
        mandatory: true,
        allowed: ObsDeinterlaceMode.values.map((e) => e.name).toList(),
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final deinterlaceModeName = argResults!['deinterlaceMode'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final mode = ObsDeinterlaceMode.values.byName(deinterlaceModeName);

    await obs.inputs.setInputDeinterlaceMode(
      inputName: inputName,
      inputUuid: inputUuid,
      deinterlaceMode: mode,
    );

    await obs.close();
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

    await obs.close();
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
        allowed: ObsDeinterlaceFieldOrder.values.map((e) => e.name).toList(),
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final inputName = argResults!['inputName'] as String?;
    final inputUuid = argResults!['inputUuid'] as String?;
    final fieldOrderName = argResults!['deinterlaceFieldOrder'] as String;

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'One of inputName or inputUuid must be provided.',
        usage,
      );
    }

    final order = ObsDeinterlaceFieldOrder.values.byName(fieldOrderName);

    await obs.inputs.setInputDeinterlaceFieldOrder(
      inputName: inputName,
      inputUuid: inputUuid,
      deinterlaceFieldOrder: order,
    );

    await obs.close();
  }
}
