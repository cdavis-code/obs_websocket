import 'package:loggy/loggy.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:universal_io/io.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) async {
  final config = loadYaml(File('config.yaml').readAsStringSync());

  final obs = await ObsWebSocket.connect(
    config['host'],
    password: config['password'],
    logOptions: const LogOptions(LogLevel.debug),
    fallbackEventHandler: (Event event) =>
        print('type: ${event.eventType} data: ${event.eventData}'),
  );

  final requests = [
    Request('GetVersion'),
    Request('GetHotkeyList'),
    Request('GetStreamStatus'),
  ];

  final result = await obs.sendBatch(requests);

  for (final requestResponse in result.results) {
    print(
        'response type: ${requestResponse.requestType}, with status code: ${requestResponse.requestStatus.code}');
  }
}
