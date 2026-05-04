import 'package:obs_cli/src/cmd/obs_helper_command.dart';

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

    await obs.close();
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

    await obs.close();
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

    await obs.close();
  }
}
