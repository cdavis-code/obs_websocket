import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_websocket/obs_websocket.dart' show ObsUtil, ObsWebSocket;
import 'package:universal_io/io.dart';

abstract class ObsHelperCommand extends Command<void> {
  ObsWebSocket? _obs;

  ObsWebSocket get obs => _obs!;

  Future<void> initializeObs() async {
    final config = <String, dynamic>{};

    if (globalResults?['uri'] == null) {
      final configFile = File('${ObsUtil.userHome}/.obs/credentials.json');

      if (!configFile.existsSync()) {
        throw UsageException('OBS connection information not provided.', usage);
      }

      config.addAll(json.decode(configFile.readAsStringSync()));
    } else {
      config['uri'] = globalResults!['uri'];

      if (globalResults?['passwd'] != null) {
        config['password'] = globalResults!['passwd'];
      }
    }

    _obs = await ObsWebSocket.connect(
      config['uri']!,
      password: config['password'],
      timeout: Duration(
        seconds: globalResults?['timeout'] == null
            ? 5
            : int.parse(globalResults!['timeout']),
      ),
      logOptions: ObsUtil.convertToLogOptions(globalResults!['log-level']),
    );
  }
}
