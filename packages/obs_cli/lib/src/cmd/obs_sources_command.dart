import 'package:args/command_runner.dart';
import 'package:obs_cli/obs_cli.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Sources Requests
class ObsSourcesCommand extends Command<void> {
  @override
  String get description => 'Commands that manipulate OBS sources';

  @override
  String get name => 'sources';

  ObsSourcesCommand() {
    addSubcommand(ObsGetSourceActiveCommand());
    addSubcommand(ObsGetSourceScreenshotCommand());
    addSubcommand(ObsSaveSourceScreenshotCommand());
  }
}

/// Gets the active and show state of a source.
class ObsGetSourceActiveCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the active and show state of a source.';

  @override
  String get name => 'get-source-active';

  ObsGetSourceActiveCommand() {
    argParser.addOption(
      'source-name',
      mandatory: true,
      valueHelp: 'string',
      help: 'Name of the source to get the active state of',
    );
  }

  @override
  void run() async {
    await initializeObs();

    final sourceActiveResponse = await obs.sources.active(
      argResults?['source-name'],
    );

    print(sourceActiveResponse);

    await obs.close();
  }
}

/// Gets a Base64-encoded screenshot of a source.
///
/// The imageWidth and imageHeight parameters are treated as "scale to inner", meaning the smallest ratio will be used and the aspect ratio of the original resolution is kept. If imageWidth and imageHeight are not specified, the compressed image will use the full resolution of the source.
class ObsGetSourceScreenshotCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets a Base64-encoded screenshot of a source.';

  @override
  String get name => 'get-source-screenshot';

  ObsGetSourceScreenshotCommand() {
    argParser
      ..addOption(
        'source-name',
        mandatory: true,
        valueHelp: 'string',
        help: 'Name of the source to take a screenshot of',
      )
      ..addOption(
        'image-format',
        mandatory: true,
        valueHelp: 'string',
        help:
            'Image compression format to use. Use GetVersion to get compatible image formats',
      );
  }

  @override
  void run() async {
    await initializeObs();

    final sourceScreenshotResponse = await obs.sources.getSourceScreenshot(
      SourceScreenshot(
        sourceName: argResults!['source-name'],
        imageFormat: argResults!['image-format'],
      ),
    );

    print(sourceScreenshotResponse);

    await obs.close();
  }
}

/// Saves a screenshot of a source to the filesystem.
class ObsSaveSourceScreenshotCommand extends ObsHelperCommand {
  @override
  String get description => 'Saves a screenshot of a source to the filesystem.';

  @override
  String get name => 'save-source-screenshot';

  ObsSaveSourceScreenshotCommand() {
    argParser
      ..addOption(
        'source-name',
        mandatory: true,
        valueHelp: 'string',
        help: 'Name of the source to take a screenshot of',
      )
      ..addOption(
        'image-format',
        mandatory: true,
        valueHelp: 'string',
        help:
            'Image compression format to use. Use GetVersion to get compatible image formats',
      )
      ..addOption(
        'image-file-path',
        mandatory: true,
        valueHelp: 'string',
        help: 'Path to save the screenshot file to.',
      );
  }

  @override
  void run() async {
    await initializeObs();

    final sourceScreenshotResponse = await obs.sources.screenshot(
      SourceScreenshot(
        sourceName: argResults!['source-name'],
        imageFormat: argResults!['image-format'],
        imageFilePath: argResults!['image-file-path'],
      ),
    );

    print(sourceScreenshotResponse);

    await obs.close();
  }
}
