import 'dart:convert';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/src/connect.dart';
import 'package:obs_websocket/request.dart' as request;
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ObsWebSocket with UiLoggy {
  final WebSocketChannel websocketChannel;

  final Stream<dynamic> broadcastStream;

  final String? password;

  final Function? onDone;

  final List<Function> fallbackHandlers = [];

  final eventHandlers = <String, List<Function>>{};

  final fromJsonSingleton = FromJsonSingleton();

  request.Config? _config;

  request.Filters? _filters;

  request.General? _general;

  request.Inputs? _inputs;

  request.MediaInputs? _mediaInputs;

  request.Outputs? _outputs;

  request.Scenes? _scenes;

  request.SceneItems? _sceneItems;

  request.Record? _record;

  request.Sources? _sources;

  request.Stream? _stream;

  request.Transitions? _transitions;

  request.Ui? _ui;

  bool handshakeComplete = false;

  int? _negotiatedRpcVersion;

  int messageId = 0;

  int get negotiatedRpcVersion => handshakeComplete
      ? _negotiatedRpcVersion!
      : throw Exception('authentication not completed');

  request.Config get config => _config!;

  request.Filters get filters => _filters!;

  request.General get general => _general!;

  request.Inputs get inputs => _inputs!;

  request.MediaInputs get mediaInputs => _mediaInputs!;

  request.Outputs get outputs => _outputs!;

  request.Record get record => _record!;

  request.Scenes get scenes => _scenes!;

  request.SceneItems get sceneItems => _sceneItems!;

  request.Sources get sources => _sources!;

  request.Stream get stream => _stream!;

  request.Transitions get transitions => _transitions!;

  request.Ui get ui => _ui!;

  static Map<int, int> opCodeResponseMap = {
    WebSocketOpCode.identify.code: WebSocketOpCode.identified.code,
    WebSocketOpCode.request.code: WebSocketOpCode.requestResponse.code,
    WebSocketOpCode.requestBatch.code:
        WebSocketOpCode.requestBatchResponse.code,
  };

  ///When the object is created we open the websocket connection and create a
  ///broadcast stream so that we can have multiple listeners providing responses
  ///to commands. [websocketChannel] is an existing [WebSocketChannel].
  ObsWebSocket(
    this.websocketChannel, {
    this.password,
    this.onDone,
    Function? fallbackEventHandler,
  }) : broadcastStream = websocketChannel.stream.asBroadcastStream() {
    _config = request.Config(this);

    _filters = request.Filters(this);

    _general = request.General(this);

    _inputs = request.Inputs(this);

    _mediaInputs = request.MediaInputs(this);

    _outputs = request.Outputs(this);

    _record = request.Record(this);

    _scenes = request.Scenes(this);

    _sceneItems = request.SceneItems(this);

    _sources = request.Sources(this);

    _stream = request.Stream(this);

    _transitions = request.Transitions(this);

    _ui = request.Ui(this);

    if (fallbackEventHandler != null) {
      addFallbackListener(fallbackEventHandler);
    }
  }

  static Future<ObsWebSocket> connect(
    String connectUrl, {
    String? password,
    Duration timeout = const Duration(seconds: 120),
    void Function()? onDone,
    Function? fallbackEventHandler,
    LogOptions logOptions = const LogOptions(
      LogLevel.error,
      stackTraceLevel: LogLevel.off,
    ),
    LoggyPrinter printer = const PrettyPrinter(showColors: false),
  }) async {
    Loggy.initLoggy(logPrinter: printer, logOptions: logOptions);

    if (!connectUrl.startsWith('ws://')) {
      connectUrl = 'ws://$connectUrl';
    }

    logDebug('connecting to $connectUrl');

    final webSocketChannel = await Connect().connect(
      connectUrl: connectUrl,
      timeout: timeout,
    );

    final obsWebSocket = ObsWebSocket(
      webSocketChannel,
      password: password,
      onDone: onDone,
      fallbackEventHandler: fallbackEventHandler,
    );

    logDebug('connected');

    await obsWebSocket.init();

    return obsWebSocket;
  }

  Future<void> init() async {
    broadcastStream.listen((message) {
      final opcode = Opcode.fromJson(json.decode(message));

      if (opcode.op == WebSocketOpCode.event.code) {
        final event = Event.fromJson(opcode.d);

        loggy.debug('event: $event');

        _handleEvent(event);
      }
    });

    await authenticate();
  }

  Future<void> authenticate() async {
    loggy.debug('starting handshake');

    final helloOpcode = await getStreamOpcode(WebSocketOpCode.hello.code);

    if (helloOpcode == null) {
      throw Exception('Handshake error with Hello response');
    }

    final hello = Hello.fromJson(helloOpcode.d);

    final Authentication? authentication = hello.authentication;

    String? authToken;

    if (authentication != null) {
      logDebug('authenticating with supplied password');

      final secret = ObsUtil.base64Hash('$password${authentication.salt}');

      authToken = ObsUtil.base64Hash('$secret${authentication.challenge}');
    } else {
      logDebug('authenticating anonymously');
    }

    final identifyOpcode = Identify(
      rpcVersion: hello.rpcVersion,
      authentication: authToken,
      eventSubscriptions: EventSubscription.none.code,
    ).toOpcode();

    final identifiedOpcode = await sendOpcode(identifyOpcode);

    if (identifiedOpcode == null) {
      throw Exception('Authentication error with identified response');
    }

    final identified = Identified.fromJson(identifiedOpcode.d);

    _negotiatedRpcVersion = identified.negotiatedRpcVersion;

    handshakeComplete = true;

    loggy.debug('negotiatedRpcVersion: $negotiatedRpcVersion');

    loggy.debug('handshake complete');
  }

  Future<Opcode?> getStreamOpcode(int? webSocketOpCode) async {
    Opcode? opcode;

    if (webSocketOpCode == null) {
      return null;
    }

    await for (String message in broadcastStream) {
      loggy.debug('rcv raw opcode: $message');

      opcode = Opcode.fromJson(json.decode(message));

      if (opcode.op == webSocketOpCode) {
        return opcode;
      }
    }

    return opcode;
  }

  Future<Opcode?> sendOpcode(Opcode opcode) async {
    loggy.debug('send opcode: $opcode');

    websocketChannel.sink.add(opcode.toString());

    return await getStreamOpcode(opCodeResponseMap[opcode.op]);
  }

  /// Listen to a specific event subscription, the original code
  Future<void> listenForMask(int eventSubscriptions) async => await sendOpcode(
    ReIdentifyOpcode(ReIdentify(eventSubscriptions: eventSubscriptions)),
  );

  /// Listen to a specific event subscription.
  @Deprecated('Use subscribe instead')
  Future<void> listen(dynamic eventSubscription) async =>
      await listenForMask(switch (eventSubscription.runtimeType) {
        const (EventSubscription) => eventSubscription.code,
        const (int) => eventSubscription,
        _ => 0,
      });

  /// subscribe to all events based on the [eventSubscription] mask.
  /// Can accept either an EventSubscription enum value or an int from combining subscriptions.
  Future<void> subscribe(dynamic eventSubscription) async {
    if (eventSubscription is EventSubscription) {
      await listenForMask(eventSubscription.code);
    } else if (eventSubscription is int) {
      await listenForMask(eventSubscription);
    } else {
      throw ArgumentError(
        'eventSubscription must be either EventSubscription or int, got ${eventSubscription.runtimeType}',
      );
    }
  }

  /// Look at the raw [event] data and run the appropriate event handler
  void _handleEvent(Event event) {
    final listeners = eventHandlers[event.eventType] ?? [];

    if (listeners.isNotEmpty) {
      for (var handler in listeners) {
        if (fromJsonSingleton.factories.containsKey(event.eventType)) {
          handler(
            fromJsonSingleton.factories[event.eventType]!(
              event.eventData ?? {},
            ),
          );
        }
      }
    } else {
      _fallback(event);
    }
  }

  ///Before execution finished the websocket needs to be closed
  Future<void> close() async {
    if (onDone != null) onDone!();

    await websocketChannel.sink.close(status.normalClosure);
  }

  ///Add an event handler for the event type [T]
  void addHandler<T>(Function listener) {
    eventHandlers['$T'] ??= <Function>[];

    eventHandlers['$T']?.add(listener);
  }

  ///Remove an event handler for the event type [T]
  void removeHandler<T>(Function listener) {
    eventHandlers['$T'] ??= <Function>[];

    eventHandlers['$T']?.remove(listener);
  }

  ///Add an event handler for an event that don't have a specific class
  void addFallbackListener(Function listener) {
    fallbackHandlers.add(listener);
  }

  ///Remove an event handler for an event that don't have a specific class
  void removeFallbackListener(Function listener) {
    fallbackHandlers.remove(listener);
  }

  ///Handler when none of the others match the event class
  void _fallback(Event event) {
    for (var handler in fallbackHandlers) {
      handler(event);
    }
  }

  Future<RequestResponse?> send(
    String command, [
    Map<String, dynamic>? args,
  ]) async => await sendRequest(Request(command, requestData: args));

  Future<RequestBatchResponse> sendBatch(List<Request> requests) async {
    RequestBatchResponse? requestBatchResponse;

    final requestBatch = RequestBatch(requests: requests);

    final requestBatchOpcode = requestBatch.toOpcode();

    loggy.debug('send batch: $requestBatchOpcode');

    websocketChannel.sink.add(requestBatchOpcode.toString());

    await for (String message in broadcastStream) {
      final response = Opcode.fromJson(json.decode(message));

      loggy.debug('response raw: $message');

      if (response.op == WebSocketOpCode.requestBatchResponse.code) {
        requestBatchResponse = RequestBatchResponse.fromJson(response.d);

        loggy.debug(
          'batch response size: ${requestBatchResponse.results.length}',
        );

        if (requestBatchResponse.requestId == requestBatch.requestId) break;
      }
    }

    if (requestBatchResponse == null) {
      throw Exception('Problem retrieving batch response.');
    }

    return requestBatchResponse;
  }

  Future<RequestResponse?> sendRequest(Request request) async {
    RequestResponse? requestResponse;

    loggy.debug('send ${request.requestType}: ${request.toOpcode()}');

    websocketChannel.sink.add(request.toOpcode().toString());

    await for (String message in broadcastStream) {
      final response = Opcode.fromJson(json.decode(message));

      loggy.debug('response raw: $message');

      if (response.op == WebSocketOpCode.requestResponse.code) {
        requestResponse = RequestResponse.fromJson(response.d);

        loggy.debug(
          'response status: ${requestResponse.requestType} ${requestResponse.requestStatus}',
        );

        if (request.requestId == requestResponse.requestId) {
          _checkResponse(request, requestResponse);

          break;
        }
      }
    }

    return requestResponse;
  }

  void _checkResponse(Request request, RequestResponse response) {
    if (request.hasResponseData && !response.requestStatus.result) {
      throw Exception(
        'Problem with command: ${request.requestType}, Error Code: ${response.requestStatus.code}, Message: ${response.requestStatus.comment}',
      );
    }
  }
}
