import 'dart:io';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Example demonstrating batch request operations using .env file for credentials.
void main(List<String> args) async {
  // Connect using .env file or environment variables
  final obs = await ObsWebSocket.connectFromEnv(
    logOptions: const LogOptions(LogLevel.debug),
    fallbackEventHandler: (Event event) =>
        print('Event: ${event.eventType} | Data: ${event.eventData}'),
  );

  if (obs == null) {
    print(
      'Error: No OBS connection configured.\n'
      'Set OBS_WEBSOCKET_URL environment variable or create a .env file.',
    );
    exit(1);
  }

  final requests = [
    Request('GetVersion'),
    Request('GetHotkeyList'),
    Request('GetStreamStatus'),
  ];

  final result = await obs.sendBatch(requests);

  for (final requestResponse in result.results) {
    print(
        'Response type: ${requestResponse.requestType}, with status code: ${requestResponse.requestStatus.code}');
  }

  await obs.close();
}
