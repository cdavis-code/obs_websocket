import 'dart:convert';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:obs_cli/command.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Config Requests
class ObsConfigCommand extends Command<void> {
  @override
  String get description => 'Config Requests';

  @override
  String get name => 'config';

  ObsConfigCommand() {
    addSubcommand(ObsGetVideoSettingsCommand());
    addSubcommand(ObsSetVideoSettingsCommand());
    addSubcommand(ObsGetStreamServiceSettingsCommand());
    addSubcommand(ObsSetStreamServiceSettingsCommand());
    addSubcommand(ObsGetRecordDirectoryCommand());
    // addSubcommand(ObsGetHotkeyListCommand());
    // addSubcommand(ObsTriggerHotkeyByNameCommand());
    // addSubcommand(ObsTriggerHotkeyByKeySequenceCommand());
    // addSubcommand(ObSleepCommand());
  }
}

/// Gets the current video settings.
class ObsGetVideoSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the current video settings.';

  @override
  String get name => 'get-video-settings';

  @override
  void run() async {
    await initializeObs();

    final videoSettingsResponse = await obs.config.getVideoSettings();

    print(videoSettingsResponse);

    obs.close();
  }
}

/// Sets the current video settings.
class ObsSetVideoSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the current video settings.';

  @override
  String get name => 'set-video-settings';

  ObsSetVideoSettingsCommand() {
    argParser
      ..addOption(
        'fps-numerator',
        valueHelp: 'int (greater than 0)',
        help: 'Numerator of the fractional FPS value',
        callback: _greaterThanZero,
      )
      ..addOption(
        'fps-denominator',
        valueHelp: 'int (greater than 0)',
        help: 'Denominator of the fractional FPS value',
        callback: _greaterThanZero,
      )
      ..addOption(
        'base-width',
        valueHelp: 'int (between 1 and 4096)',
        help: 'Width of the base (canvas) resolution in pixels',
        callback: _betweenOneAndFortyNinetySix,
      )
      ..addOption(
        'base-height',
        valueHelp: 'int (between 1 and 4096)',
        help: 'Height of the base (canvas) resolution in pixels',
        callback: _betweenOneAndFortyNinetySix,
      )
      ..addOption(
        'output-width',
        valueHelp: 'int (between 1 and 4096)',
        help: 'Width of the output resolution in pixels',
        callback: _betweenOneAndFortyNinetySix,
      )
      ..addOption(
        'output-height',
        valueHelp: 'int (between 1 and 4096)',
        help: 'Height of the output resolution in pixels',
        callback: _betweenOneAndFortyNinetySix,
      );
  }

  void _greaterThanZero(String? value) => Validate.isGreaterOrEqual(value, 1)
      ? null
      : throw ArgParserException('$value is outside of specified range.');

  void _betweenOneAndFortyNinetySix(String? value) =>
      Validate.isInRange(value, start: 1, end: 4096)
      ? null
      : throw ArgParserException('$value is outside of specified range.');

  @override
  void run() async {
    await initializeObs();

    await obs.config.setVideoSettings(
      VideoSettings(
        fpsNumerator: argResults?['fps-numerator'],
        fpsDenominator: argResults?['fps-denominator'],
        baseWidth: argResults?['base-width'],
        baseHeight: argResults?['base-height'],
        outputWidth: argResults?['output-width'],
        outputHeight: argResults?['output-height'],
      ),
    );

    obs.close();
  }
}

/// Gets the current stream service settings (stream destination).
class ObsGetStreamServiceSettingsCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets the current stream service settings (stream destination).';

  @override
  String get name => 'get-stream-service-settings';

  @override
  void run() async {
    await initializeObs();

    final streamServiceSettingsResponse = await obs.config
        .getStreamServiceSettings();

    print(streamServiceSettingsResponse);

    obs.close();
  }
}

/// Sets the current video settings.
class ObsSetStreamServiceSettingsCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Sets the current stream service settings (stream destination).';

  @override
  String get name => 'set-stream-service-settings';

  ObsSetStreamServiceSettingsCommand() {
    argParser
      ..addOption(
        'stream-service-type',
        mandatory: true,
        valueHelp: 'string',
        help:
            'Type of stream service to apply. Example: rtmp_common or rtmp_custom',
      )
      ..addOption(
        'stream-service-settings',
        mandatory: true,
        valueHelp: 'json',
        help: 'Settings to apply to the service',
      );
  }

  @override
  void run() async {
    await initializeObs();

    await obs.config.setStreamServiceSettings(
      streamServiceType: argResults!['stream-service-type'],
      streamServiceSettings: json.decode(
        argResults!['stream-service-settings'],
      ),
    );

    obs.close();
  }
}

/// Gets the current directory that the record output is set to.
class ObsGetRecordDirectoryCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets the current directory that the record output is set to.';

  @override
  String get name => 'get-record-directory';

  @override
  void run() async {
    await initializeObs();

    final result = await obs.config.getRecordDirectory();

    print(result.recordDirectory);

    obs.close();
  }
}
