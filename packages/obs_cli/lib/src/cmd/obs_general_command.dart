import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_cli/obs_cli.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// General Requests
class ObsGeneralCommand extends Command<void> {
  @override
  String get description => 'General commands';

  @override
  String get name => 'general';

  ObsGeneralCommand() {
    addSubcommand(ObsGetVersionCommand());
    addSubcommand(ObsGetStatsCommand());
    addSubcommand(ObsBroadcastCustomEventCommand());
    addSubcommand(ObsCallVendorRequestCommand());
    addSubcommand(ObsBrowserEventCommand());
    addSubcommand(ObsGetHotkeyListCommand());
    addSubcommand(ObsTriggerHotkeyByNameCommand());
    addSubcommand(ObsTriggerHotkeyByKeySequenceCommand());
    addSubcommand(ObSleepCommand());
  }
}

/// Gets data about the current plugin and RPC version.
class ObsGetVersionCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets data about the current plugin and RPC version.';

  @override
  String get name => 'get-version';

  @override
  void run() async {
    await initializeObs();

    final versionResponse = await obs.general.version;

    print(versionResponse);

    await obs.close();
  }
}

/// Gets statistics about OBS, obs-websocket, and the current session.
class ObsGetStatsCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets statistics about OBS, obs-websocket, and the current session.';

  @override
  String get name => 'get-stats';

  @override
  void run() async {
    await initializeObs();

    final statsResponse = await obs.general.stats;

    print(statsResponse);

    await obs.close();
  }
}

/// Broadcasts a CustomEvent to all WebSocket clients. Receivers are clients which are identified and subscribed.
class ObsBroadcastCustomEventCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Broadcasts a CustomEvent to all WebSocket clients. Receivers are clients which are identified and subscribed.';

  @override
  String get name => 'broadcast-custom-event';

  ObsBroadcastCustomEventCommand() {
    argParser.addOption(
      'event-data',
      mandatory: true,
      valueHelp: 'json',
      help: 'Data payload to emit to all receivers',
    );
  }

  @override
  void run() async {
    await initializeObs();

    await obs.general.broadcastCustomEvent(argResults!['event-data']);

    await obs.close();
  }
}

/// Call a request registered to a vendor.
///
/// A vendor is a unique name registered by a third-party plugin or script, which allows for custom requests and events to be added to obs-websocket. If a plugin or script implements vendor requests or events, documentation is expected to be provided with them.
class ObsCallVendorRequestCommand extends ObsHelperCommand {
  @override
  String get description => 'Send a request registered to a vendor.';

  @override
  String get name => 'call-vendor-request';

  ObsCallVendorRequestCommand() {
    argParser
      ..addOption(
        'vendor-name',
        mandatory: true,
        valueHelp: 'string',
        help: 'Name of the vendor to use',
      )
      ..addOption(
        'request-type',
        mandatory: true,
        valueHelp: 'string',
        help: 'The request type to call',
      )
      ..addOption(
        'request-data',
        valueHelp: 'json',
        help: 'JSON encoded object containing appropriate request data',
      );
  }

  @override
  void run() async {
    await initializeObs();

    final callVendorRequestResponse = await obs.general.callVendorRequest(
      vendorName: argResults!['vendor-name'],
      requestType: argResults!['request-type'],
      requestData: argResults?['request-data'],
    );

    print(callVendorRequestResponse);

    await obs.close();
  }
}

/// Helper method to send a VendorRequest specifically to the 'obs-browser' plugin.
class ObsBrowserEventCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Send a VendorRequest specifically to the \'obs-browser\' plugin';

  @override
  String get name => 'obs-browser-event';

  ObsBrowserEventCommand() {
    argParser
      ..addOption(
        'event-name',
        mandatory: true,
        valueHelp: 'string',
        help: 'Name of the vendor to use',
      )
      ..addOption(
        'event-data',
        valueHelp: 'json',
        help: 'JSON encoded object containing appropriate event data',
      );
  }

  @override
  void run() async {
    await initializeObs();

    final callVendorRequestResponse = await obs.general.obsBrowserEvent(
      eventName: argResults!['event-name'],
      eventData: argResults?['event-data'],
    );

    print(callVendorRequestResponse);

    await obs.close();
  }
}

/// Gets an array of all hotkey names in OBS
class ObsGetHotkeyListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all hotkey names in OBS';

  @override
  String get name => 'get-hotkey-list';

  @override
  void run() async {
    await initializeObs();

    final hotkeyList = await obs.general.hotkeyList;

    print(hotkeyList);

    await obs.close();
  }
}

/// Triggers a hotkey using its name. See `ObsGetHotkeyListCommand`.
class ObsTriggerHotkeyByNameCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Triggers a hotkey using its name. See get-hotkey-list.';

  @override
  String get name => 'trigger-hotkey-by-name';

  ObsTriggerHotkeyByNameCommand() {
    argParser.addOption(
      'hotkey-name',
      mandatory: true,
      valueHelp: 'string',
      help: 'Name of the hotkey to trigger',
    );
  }

  @override
  void run() async {
    await initializeObs();

    await obs.general.triggerHotkeyByName(argResults!['hotkey-name']);

    await obs.close();
  }
}

/// Triggers a hotkey using a sequence of keys.
class ObsTriggerHotkeyByKeySequenceCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Triggers a hotkey using its name. See get-hotkey-list.';

  @override
  String get name => 'trigger-hotkey-by-key-sequence';

  ObsTriggerHotkeyByKeySequenceCommand() {
    argParser
      ..addOption(
        'key-id',
        mandatory: true,
        valueHelp: 'string',
        help:
            'The OBS key ID to use. See https://github.com/obsproject/obs-studio/blob/master/libobs/obs-hotkeys.h',
      )
      ..addOption(
        'key-modifiers',
        valueHelp: 'json',
        help: 'Object containing key modifiers to apply',
      );
  }

  @override
  void run() async {
    await initializeObs();

    await obs.general.triggerHotkeyByKeySequence(
      keyId: argResults!['key-id'],
      keyModifiers: KeyModifiers.fromJson(
        json.decode(argResults!['key-modifiers']),
      ),
    );

    await obs.close();
  }
}

/// Sleeps for a time duration or number of frames. Only available in request batches with types SERIAL_REALTIME or SERIAL_FRAME.
class ObSleepCommand extends ObsHelperCommand {
  @override
  String get description => 'Sleeps for a time duration or number of frames.';

  @override
  String get name => 'sleep';

  ObSleepCommand() {
    argParser
      ..addOption(
        'sleep-millis',
        valueHelp: 'number from 0 to 50000',
        help: 'Number of milliseconds to sleep for (if SERIAL_REALTIME mode)',
      )
      ..addOption(
        'sleep-frames',
        valueHelp: 'number from 0 to 10000',
        help: 'Number of frames to sleep for (if SERIAL_FRAME mode)',
      );
  }

  @override
  void run() async {
    await initializeObs();

    await obs.general.sleep(
      sleepMillis: argResults?['sleep-millis'],
      sleepFrames: argResults?['sleep-frames'],
    );

    await obs.close();
  }
}
