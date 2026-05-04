import 'package:obs_cli/obs_cli.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Listen fir OBS events
class ObsSendCommand extends ObsHelperCommand {
  @override
  String get description => 'Send a low-level websocket request to OBS';

  @override
  String get name => 'send';

  ObsSendCommand() {
    argParser
      ..addOption(
        'command',
        mandatory: true,
        abbr: 'c',
        valueHelp: 'string',
        help:
            'One of the OBS web socket supported requests - https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#requests-table-of-contents',
      )
      ..addOption(
        'args',
        abbr: 'a',
        valueHelp: 'json string',
        help:
            'The json representing the arguments necessary for the supplied command.',
      );
  }

  @override
  void run() async {
    await initializeObs();

    final requestResponse = await obs.sendRequest(
      Request(argResults!['command'], requestData: argResults?['args']),
    );

    if (requestResponse != null) {
      print(requestResponse);
    }

    await obs.close();
  }
}
