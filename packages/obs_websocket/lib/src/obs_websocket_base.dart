import 'dart:convert';

import 'package:loggy/loggy.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/src/connect.dart';
import 'package:obs_websocket/request.dart' as request;
import 'package:universal_io/io.dart';
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

  request.Canvas? _canvas;

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
      : throw const ObsAuthenticationException('Authentication not completed');

  request.Config get config => _config!;

  request.Canvas get canvas => _canvas!;

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

    _canvas = request.Canvas(this);

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

    connectUrl = _normalizeConnectUrl(connectUrl);

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

  /// Connects to OBS using credentials from environment variables or a `.env`
  /// file.
  ///
  /// **Priority order (highest to lowest):**
  ///   1. System environment variables: `OBS_WEBSOCKET_URL`, `OBS_WEBSOCKET_PASSWORD`,
  ///      `OBS_WEBSOCKET_TIMEOUT`
  ///   2. `.env` file in the project root
  ///
  /// **Required `.env` file format:**
  /// ```env
  /// OBS_WEBSOCKET_URL=ws://localhost:4455
  /// OBS_WEBSOCKET_PASSWORD=your_password
  /// OBS_WEBSOCKET_TIMEOUT=120
  /// ```
  ///
  /// **Example usage:**
  /// ```dart
  /// final obs = await ObsWebSocket.connectFromEnv();
  /// ```
  ///
  /// Returns `null` if no URL is configured.
  static Future<ObsWebSocket?> connectFromEnv({
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

    // Check system environment variables first, then fall back to .env file
    final url = Platform.environment['OBS_WEBSOCKET_URL'] ?? ObsEnv.url;
    if (url.isEmpty) {
      logDebug('No OBS_WEBSOCKET_URL found in environment or .env file');
      return null;
    }

    final password =
        Platform.environment['OBS_WEBSOCKET_PASSWORD'] ?? ObsEnv.password;
    final timeoutStr =
        Platform.environment['OBS_WEBSOCKET_TIMEOUT'] ?? ObsEnv.timeout;
    final timeoutSeconds = int.tryParse(timeoutStr) ?? timeout.inSeconds;

    return connect(
      url,
      password: password.isEmpty ? null : password,
      timeout: Duration(seconds: timeoutSeconds),
      onDone: onDone,
      fallbackEventHandler: fallbackEventHandler,
      logOptions: logOptions,
      printer: printer,
    );
  }

  /// Validates [input] and returns a normalized `ws://` or `wss://` URL.
  ///
  /// - A scheme-less input like `host:4455` is prefixed with `ws://`.
  /// - `ws://` and `wss://` are preserved as-is.
  /// - Any other scheme (http, wss typo, ftp, ...) throws
  ///   [ObsArgumentException] so callers never get a silently rewritten URL.
  static String _normalizeConnectUrl(String input) {
    final parsed = Uri.tryParse(input);
    if (parsed == null) {
      throw ObsArgumentException('Invalid WebSocket URL: $input');
    }
    if (parsed.scheme.isEmpty) {
      return 'ws://$input';
    }
    if (parsed.scheme != 'ws' && parsed.scheme != 'wss') {
      throw ObsArgumentException(
        'Only ws:// and wss:// schemes are supported, got ${parsed.scheme}://',
      );
    }
    return input;
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
      throw const ObsConnectionException(
        'Handshake error: no Hello opcode received from server',
      );
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
      throw const ObsAuthenticationException(
        'Authentication error: no Identified opcode received from server',
      );
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
      throw ObsArgumentException(
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
      throw const ObsConnectionException(
        'Batch response not received before stream closed',
      );
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
      throw ObsRequestException(
        requestType: request.requestType,
        code: response.requestStatus.code,
        comment: response.requestStatus.comment,
        stackTrace: StackTrace.current,
      );
    }
  }
}
