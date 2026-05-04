import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';

/// Record Requests
class ObsRecordCommand extends Command<void> {
  @override
  String get description => 'Record Requests';

  @override
  String get name => 'record';

  ObsRecordCommand() {
    addSubcommand(ObsGetRecordStatusCommand());
    addSubcommand(ObsToggleRecordCommand());
    addSubcommand(ObsStartRecordCommand());
    addSubcommand(ObsStopRecordCommand());
    addSubcommand(ObsToggleRecordPauseCommand());
    addSubcommand(ObsPauseRecordCommand());
    addSubcommand(ObsResumeRecordCommand());
    addSubcommand(ObsSplitRecordFileCommand());
    addSubcommand(ObsCreateRecordChapterCommand());
  }
}

/// Gets the status of the record output.
class ObsGetRecordStatusCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the status of the record output.';

  @override
  String get name => 'get-record-status';

  @override
  Future<void> run() async {
    await initializeObs();

    final status = await obs.record.getRecordStatus();

    print(status);

    obs.close();
  }
}

/// Toggles the status of the record output.
class ObsToggleRecordCommand extends ObsHelperCommand {
  @override
  String get description => 'Toggles the status of the record output.';

  @override
  String get name => 'toggle-record';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.record.toggleRecord();

    print('Recording toggled');

    obs.close();
  }
}

/// Starts the record output.
class ObsStartRecordCommand extends ObsHelperCommand {
  @override
  String get description => 'Starts the record output.';

  @override
  String get name => 'start-record';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.record.startRecord();

    print('Recording started');

    obs.close();
  }
}

/// Stops the record output.
class ObsStopRecordCommand extends ObsHelperCommand {
  @override
  String get description => 'Stops the record output.';

  @override
  String get name => 'stop-record';

  @override
  Future<void> run() async {
    await initializeObs();

    final outputPath = await obs.record.stopRecord();

    print('Recording stopped');
    print('Output path: $outputPath');

    obs.close();
  }
}

/// Toggles pause on the record output.
class ObsToggleRecordPauseCommand extends ObsHelperCommand {
  @override
  String get description => 'Toggles pause on the record output.';

  @override
  String get name => 'toggle-record-pause';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.record.toggleRecordPause();

    print('Record pause toggled');

    obs.close();
  }
}

/// Pauses the record output.
class ObsPauseRecordCommand extends ObsHelperCommand {
  @override
  String get description => 'Pauses the record output.';

  @override
  String get name => 'pause-record';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.record.pauseRecord();

    print('Recording paused');

    obs.close();
  }
}

/// Resumes the record output.
class ObsResumeRecordCommand extends ObsHelperCommand {
  @override
  String get description => 'Resumes the record output.';

  @override
  String get name => 'resume-record';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.record.resumeRecord();

    print('Recording resumed');

    obs.close();
  }
}

/// Splits the current recording file (v5.5.0+).
class ObsSplitRecordFileCommand extends ObsHelperCommand {
  @override
  String get description => 'Splits the current recording file.';

  @override
  String get name => 'split-record-file';

  @override
  Future<void> run() async {
    await initializeObs();

    await obs.record.splitRecordFile();

    print('Record file split');

    obs.close();
  }
}

/// Creates a chapter marker in the current recording file (v5.5.0+).
class ObsCreateRecordChapterCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Creates a chapter marker in the current recording file.';

  @override
  String get name => 'create-record-chapter';

  ObsCreateRecordChapterCommand() {
    argParser.addOption('chapterName', help: 'Name of the chapter to create');
  }

  @override
  Future<void> run() async {
    await initializeObs();

    final chapterName = argResults!['chapterName'] as String?;

    await obs.record.createRecordChapter(chapterName: chapterName);

    print('Chapter created: ${chapterName ?? "unnamed"}');

    obs.close();
  }
}
