/// MCP facade for the OBS WebSocket client.
///
/// [ObsMcpServer] wraps [ObsWebSocket] and exposes every OBS request group
/// (`general`, `config`, `scenes`, `inputs`, `media_inputs`, `outputs`,
/// `record`, `scene_items`, `sources`, `stream`, `transitions`, `ui`) as
/// MCP tools via the `easy_api_annotations` package.
///
/// The class is annotated with
/// `@Server(transport: McpTransport.stdio)` so the generator
/// produces a stdio MCP server at `obs_mcp_server.mcp.dart`.
///
/// Because the generated dispatcher constructs a fresh [ObsMcpServer] instance
/// for every tool invocation, the live connection is kept in a static field
/// so it survives across calls. All `Future<void>` wrappers return
/// `<String, dynamic>{'ok': true}` instead — the generator serialises the
/// return value into the MCP response payload and does not compile against
/// raw `void`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:easy_api_annotations/mcp_annotations.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// Unified MCP facade exposing the OBS WebSocket v5.1.0 protocol as tools.
///
/// Callers invoke [connect] once (or rely on [bootstrapFromEnv] to connect
/// automatically from `OBS_WEBSOCKET_*` environment variables), then use any
/// of the grouped tools (`obs_scenes_list`, `obs_inputs_set_mute`,
/// `obs_stream_start`, etc.).
@Server(
  transport: McpTransport.stdio,
  codeMode: true,
  toolPrefix: 'obs_',
  logErrors: true,
)
class ObsMcpServer {
  /// Environment variable holding the OBS WebSocket URL, e.g.
  /// `ws://localhost:4455`.
  static const String envUrl = 'OBS_WEBSOCKET_URL';

  /// Environment variable holding the OBS WebSocket password. Leave unset
  /// for anonymous connections.
  static const String envPassword = 'OBS_WEBSOCKET_PASSWORD';

  /// Environment variable holding the connect timeout in seconds. Defaults
  /// to 120 when unset.
  static const String envTimeout = 'OBS_WEBSOCKET_TIMEOUT';

  /// Static so the connection persists across per-tool-call instances
  /// created by the generated dispatcher.
  static ObsWebSocket? _client;

  /// Canonical acknowledgement payload for tools that have no natural
  /// return value. The generator cannot serialise `void` so every mutator
  /// returns a JSON-friendly ack.
  static const Map<String, dynamic> _ok = <String, dynamic>{'ok': true};

  /// Returns the active client or throws a descriptive [StateError] when the
  /// caller forgot to invoke [connect].
  static ObsWebSocket get _obs {
    final client = _client;
    if (client == null) {
      throw StateError(
        'Not connected to OBS. Set $envUrl (and optionally $envPassword) in '
        'the environment or a .env file, or call obs_connect(url, password).',
      );
    }
    return client;
  }

  // ---------------------------------------------------------------------------
  // Environment bootstrap
  // ---------------------------------------------------------------------------

  /// Loads OBS credentials from the process environment and/or a dotenv
  /// file, and — when a URL is present — opens the connection so tools are
  /// immediately usable. Safe to call more than once: subsequent calls are
  /// no-ops once connected.
  ///
  /// Resolution order for each variable:
  ///   1. [Platform.environment].
  ///   2. Key-value pairs parsed from the first readable dotenv candidate
  ///      in [dotenvPaths] (defaults to `.env`, `bin/.env`, and a `.env`
  ///      sibling of the running script).
  static Future<void> bootstrapFromEnv({List<String>? dotenvPaths}) async {
    if (_client != null) return;

    final fileEnv = _loadDotenvCandidates(
      dotenvPaths ?? _defaultDotenvCandidates(),
    );
    String? lookup(String key) => Platform.environment[key] ?? fileEnv[key];

    final url = lookup(envUrl);
    if (url == null || url.isEmpty) return;

    final password = lookup(envPassword);
    final timeoutSeconds = int.tryParse(lookup(envTimeout) ?? '') ?? 120;

    try {
      _client = await ObsWebSocket.connect(
        url,
        password: password,
        timeout: Duration(seconds: timeoutSeconds),
      );
    } on ObsAuthenticationException catch (error) {
      stderr.writeln(
        '[obs_mcp] bootstrapFromEnv authentication failed: ${error.message}',
      );
    } on ObsException catch (error) {
      stderr.writeln(
        '[obs_mcp] bootstrapFromEnv connect failed: ${error.message}',
      );
    } on Object catch (error) {
      // Surface the failure on stderr so MCP hosts can see it, but don't
      // abort startup — callers can still invoke obs_connect() manually.
      stderr.writeln('[obs_mcp] bootstrapFromEnv connect failed: $error');
    }
  }

  /// Default dotenv search paths. Relative entries are resolved against the
  /// current working directory; an additional candidate sits next to the
  /// running script so launching from any cwd still finds `bin/.env`.
  static List<String> _defaultDotenvCandidates() {
    final candidates = <String>['.env', 'bin/.env'];
    try {
      final scriptDir = File.fromUri(Platform.script).parent.path;
      candidates.add('$scriptDir/.env');
    } on Object catch (_) {
      // Platform.script may not resolve to a file (e.g. under tests).
    }
    return candidates;
  }

  /// Reads the first existing file from [paths] and returns its parsed
  /// contents. Returns an empty map when no file is found.
  static Map<String, String> _loadDotenvCandidates(Iterable<String> paths) {
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        return _parseDotenv(file.readAsStringSync());
      }
    }
    return const <String, String>{};
  }

  /// Minimal dependency-free dotenv parser. Supports `KEY=VALUE`,
  /// `#` comments, blank lines, `export KEY=VALUE`, and single/double-quoted
  /// values. Values are trimmed of surrounding whitespace.
  static Map<String, String> _parseDotenv(String contents) {
    final result = <String, String>{};
    for (final rawLine in const LineSplitter().convert(contents)) {
      var line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      if (line.startsWith('export ')) line = line.substring(7).trimLeft();
      final eq = line.indexOf('=');
      if (eq <= 0) continue;
      final key = line.substring(0, eq).trim();
      var value = line.substring(eq + 1).trim();
      var wasQuoted = false;
      if (value.length >= 2) {
        final first = value[0];
        final last = value[value.length - 1];
        if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
          value = value.substring(1, value.length - 1);
          wasQuoted = true;
        }
      }
      // Strip trailing inline comments for unquoted values only.
      if (!wasQuoted) {
        final hashIdx = value.indexOf(' #');
        if (hashIdx >= 0) value = value.substring(0, hashIdx).trimRight();
      }
      result[key] = value;
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Connection lifecycle
  // ---------------------------------------------------------------------------

  /// Opens a WebSocket connection to OBS Studio and completes the v5.1.0
  /// identify handshake. Reuses the single in-process connection until
  /// [disconnect] is called.
  @Tool(
    name: 'connect',
    description:
        'Connect to an OBS WebSocket server (ws:// or wss://) and '
        'authenticate. Required before any other tool can be invoked.',
  )
  Future<Map<String, dynamic>> connect({
    @Parameter(
      title: 'OBS WebSocket URL',
      description:
          'Full URL of the OBS WebSocket server. Accepts ws://host:port or '
          'wss://host:port. Bare host:port is also accepted.',
      example: 'ws://localhost:4455',
    )
    required String url,
    @Parameter(
      title: 'Password',
      description: 'OBS WebSocket password. Omit for anonymous connections.',
      sensitive: true,
    )
    String? password,
    @Parameter(
      title: 'Connect Timeout (seconds)',
      description: 'How long to wait for the TCP/WebSocket handshake.',
      example: 120,
    )
    int? timeoutSeconds,
  }) async {
    await _client?.close();
    _client = await ObsWebSocket.connect(
      url,
      password: password,
      timeout: Duration(seconds: timeoutSeconds ?? 120),
    );
    return <String, dynamic>{
      'connected': true,
      'negotiatedRpcVersion': _obs.negotiatedRpcVersion,
    };
  }

  /// Closes the active OBS WebSocket connection.
  @Tool(
    name: 'disconnect',
    description: 'Close the active OBS WebSocket connection.',
  )
  Future<Map<String, dynamic>> disconnect() async {
    await _client?.close();
    _client = null;
    return <String, dynamic>{'connected': false};
  }

  /// Reports whether a connection is currently established.
  @Tool(
    name: 'is_connected',
    description: 'Return whether a live OBS WebSocket connection is held.',
  )
  bool isConnected() => _client != null;

  /// Low-level request escape hatch for any OBS request type that does not
  /// have a dedicated tool wrapper here.
  @Tool(
    name: 'send_raw',
    description:
        'Send a raw OBS WebSocket request (requestType + optional data map) '
        'and return the response payload. Use this for requests that are not '
        'exposed directly as tools.',
  )
  Future<Map<String, dynamic>?> sendRaw({
    @Parameter(
      title: 'Request Type',
      description:
          'OBS request name, e.g. GetVersion or SetCurrentProgramScene.',
      example: 'GetVersion',
    )
    required String requestType,
    @Parameter(
      title: 'Request Data',
      description:
          'Optional JSON object of parameters accepted by the request type.',
    )
    Map<String, dynamic>? requestData,
  }) async {
    final response = await _obs.send(requestType, requestData);
    return response?.responseData;
  }

  // ---------------------------------------------------------------------------
  // General
  // ---------------------------------------------------------------------------

  /// Returns OBS and obs-websocket plugin version strings.
  @Tool(
    name: 'general_version',
    description: 'Return OBS Studio + obs-websocket version information.',
  )
  Future<Map<String, dynamic>> generalVersion() async =>
      (await _obs.general.getVersion()).toJson();

  /// Returns CPU, memory, frame-rate and render statistics.
  @Tool(
    name: 'general_stats',
    description: 'Return OBS runtime statistics (cpu, memory, frame rate).',
  )
  Future<Map<String, dynamic>> generalStats() async =>
      (await _obs.general.getStats()).toJson();

  /// Lists the names of all registered hotkeys.
  @Tool(
    name: 'general_hotkeys',
    description: 'Return the names of every registered hotkey in OBS.',
  )
  Future<List<String>> generalHotkeys() => _obs.general.getHotkeyList();

  /// Triggers a hotkey by its registered name.
  @Tool(
    name: 'general_trigger_hotkey',
    description: 'Trigger a hotkey by its registered name.',
  )
  Future<Map<String, dynamic>> generalTriggerHotkey(
    @Parameter(title: 'Hotkey Name', example: 'OBSBasic.StartStreaming')
    String hotkeyName,
  ) async {
    await _obs.general.triggerHotkeyByName(hotkeyName);
    return _ok;
  }

  /// Pauses the request pipeline for a period. Useful for orchestration
  /// scripts in code mode.
  @Tool(
    name: 'general_sleep',
    description:
        'Sleep for a duration in milliseconds or frames (executed server-side).',
  )
  Future<Map<String, dynamic>> generalSleep({
    @Parameter(
      title: 'Sleep Milliseconds',
      description: 'Wait time in milliseconds. Exclusive with sleepFrames.',
    )
    int? sleepMillis,
    @Parameter(
      title: 'Sleep Frames',
      description: 'Wait time in frames. Exclusive with sleepMillis.',
    )
    int? sleepFrames,
  }) async {
    await _obs.general.sleep(
      sleepMillis: sleepMillis,
      sleepFrames: sleepFrames,
    );
    return _ok;
  }

  /// Broadcasts a vendor-specific event payload over the websocket.
  @Tool(
    name: 'general_broadcast_custom_event',
    description: 'Broadcast a custom JSON event to all connected clients.',
  )
  Future<Map<String, dynamic>> generalBroadcastCustomEvent(
    Map<String, dynamic> eventData,
  ) async {
    await _obs.general.broadcastCustomEvent(eventData);
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Scenes
  // ---------------------------------------------------------------------------

  /// Returns the list of scenes along with the current program/preview scene.
  @Tool(
    name: 'scenes_list',
    description:
        'Return all scenes plus the current program and preview scene.',
  )
  Future<Map<String, dynamic>> scenesList() async =>
      (await _obs.scenes.list()).toJson();

  /// Returns the names of all defined groups.
  @Tool(
    name: 'scenes_group_list',
    description: 'Return the names of all groups in OBS.',
  )
  Future<List<String>> scenesGroupList() => _obs.scenes.groupList();

  /// Returns the name of the scene currently on program output.
  @Tool(
    name: 'scenes_get_current_program',
    description: 'Return the name of the scene currently on the program bus.',
  )
  Future<String> scenesGetCurrentProgram() => _obs.scenes.getCurrentProgram();

  /// Switches the program scene.
  @Tool(
    name: 'scenes_set_current_program',
    description: 'Set the program scene to the given sceneName.',
  )
  Future<Map<String, dynamic>> scenesSetCurrentProgram(
    @Parameter(title: 'Scene Name', example: 'Starting Soon') String sceneName,
  ) async {
    await _obs.scenes.setCurrentProgram(sceneName);
    return _ok;
  }

  /// Returns the name of the scene currently shown in preview
  /// (studio mode only).
  @Tool(
    name: 'scenes_get_current_preview',
    description:
        'Return the name of the preview scene (studio mode only). Throws if '
        'studio mode is disabled.',
  )
  Future<String> scenesGetCurrentPreview() => _obs.scenes.getCurrentPreview();

  /// Switches the preview scene (studio mode only).
  @Tool(
    name: 'scenes_set_current_preview',
    description: 'Set the preview scene (studio mode only).',
  )
  Future<Map<String, dynamic>> scenesSetCurrentPreview(String sceneName) async {
    await _obs.scenes.setCurrentPreview(sceneName);
    return _ok;
  }

  /// Creates a new scene.
  @Tool(
    name: 'scenes_create',
    description: 'Create a new scene with the given name.',
  )
  Future<Map<String, dynamic>> scenesCreate(
    @Parameter(title: 'Scene Name') String sceneName,
  ) async {
    await _obs.scenes.create(sceneName);
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Scene Items
  // ---------------------------------------------------------------------------

  /// Returns the scene items in a given scene (sources placed on the canvas).
  @Tool(
    name: 'scene_items_list',
    description: 'List the scene items (sources) contained in a scene.',
  )
  Future<List<Map<String, dynamic>>> sceneItemsList(String sceneName) async {
    final items = await _obs.sceneItems.list(sceneName);
    return items.map((e) => e.toJson()).toList();
  }

  /// Returns scene items inside a group.
  @Tool(
    name: 'scene_items_group_list',
    description: 'List the scene items contained in a group.',
  )
  Future<List<Map<String, dynamic>>> sceneItemsGroupList(
    String sceneName,
  ) async {
    final items = await _obs.sceneItems.groupList(sceneName);
    return items.map((e) => e.toJson()).toList();
  }

  /// Returns the numeric id for a scene item by its source name.
  @Tool(
    name: 'scene_items_get_id',
    description:
        'Return the numeric sceneItemId for a source placed in a given scene.',
  )
  Future<int> sceneItemsGetId({
    required String sceneName,
    required String sourceName,
  }) => _obs.sceneItems.getSceneItemId(
    sceneName: sceneName,
    sourceName: sourceName,
  );

  /// Returns whether a scene item is visible/enabled.
  @Tool(
    name: 'scene_items_get_enabled',
    description: 'Return whether a scene item is currently enabled (visible).',
  )
  Future<bool> sceneItemsGetEnabled({
    required String sceneName,
    required int sceneItemId,
  }) => _obs.sceneItems.getSceneItemEnabled(
    sceneName: sceneName,
    sceneItemId: sceneItemId,
  );

  /// Shows or hides a scene item.
  @Tool(
    name: 'scene_items_set_enabled',
    description: 'Show or hide a scene item by id.',
  )
  Future<Map<String, dynamic>> sceneItemsSetEnabled({
    required String sceneName,
    required int sceneItemId,
    required bool sceneItemEnabled,
  }) async {
    await _obs.sceneItems.setSceneItemEnabled(
      SceneItemEnableStateChanged(
        sceneName: sceneName,
        sceneItemId: sceneItemId,
        sceneItemEnabled: sceneItemEnabled,
      ),
    );
    return _ok;
  }

  /// Returns whether a scene item is locked.
  @Tool(
    name: 'scene_items_get_locked',
    description: 'Return whether a scene item is locked (uneditable).',
  )
  Future<bool> sceneItemsGetLocked({
    required String sceneName,
    required int sceneItemId,
  }) => _obs.sceneItems.getSceneItemLocked(
    sceneName: sceneName,
    sceneItemId: sceneItemId,
  );

  /// Locks or unlocks a scene item.
  @Tool(
    name: 'scene_items_set_locked',
    description: 'Lock or unlock a scene item by id.',
  )
  Future<Map<String, dynamic>> sceneItemsSetLocked({
    required String sceneName,
    required int sceneItemId,
    required bool sceneItemLocked,
  }) async {
    await _obs.sceneItems.setSceneItemLocked(
      sceneName: sceneName,
      sceneItemId: sceneItemId,
      sceneItemLocked: sceneItemLocked,
    );
    return _ok;
  }

  /// Sets the transform (position, scale, rotation, crop) for a scene item.
  @Tool(
    name: 'scene_items_set_transform',
    description:
        'Set the transform properties (position, scale, rotation, crop) for a '
        'scene item. Only provide the fields you want to change.',
  )
  Future<Map<String, dynamic>> sceneItemsSetTransform({
    @Parameter(title: 'Scene Name', example: 'Scene') required String sceneName,
    @Parameter(title: 'Scene Item ID', example: 4) required int sceneItemId,
    @Parameter(
      title: 'Position X',
      description: 'Horizontal position in pixels.',
    )
    num? positionX,
    @Parameter(title: 'Position Y', description: 'Vertical position in pixels.')
    num? positionY,
    @Parameter(
      title: 'Scale X',
      description: 'Horizontal scale factor (1.0 = 100%).',
    )
    num? scaleX,
    @Parameter(
      title: 'Scale Y',
      description: 'Vertical scale factor (1.0 = 100%).',
    )
    num? scaleY,
    @Parameter(title: 'Rotation', description: 'Rotation in degrees clockwise.')
    num? rotation,
    @Parameter(
      title: 'Crop Left',
      description: 'Pixels to crop from the left edge.',
    )
    int? cropLeft,
    @Parameter(
      title: 'Crop Top',
      description: 'Pixels to crop from the top edge.',
    )
    int? cropTop,
    @Parameter(
      title: 'Crop Right',
      description: 'Pixels to crop from the right edge.',
    )
    int? cropRight,
    @Parameter(
      title: 'Crop Bottom',
      description: 'Pixels to crop from the bottom edge.',
    )
    int? cropBottom,
  }) async {
    final transform = <String, dynamic>{};
    if (positionX != null) transform['positionX'] = positionX;
    if (positionY != null) transform['positionY'] = positionY;
    if (scaleX != null) transform['scaleX'] = scaleX;
    if (scaleY != null) transform['scaleY'] = scaleY;
    if (rotation != null) transform['rotation'] = rotation;
    if (cropLeft != null) transform['cropLeft'] = cropLeft;
    if (cropTop != null) transform['cropTop'] = cropTop;
    if (cropRight != null) transform['cropRight'] = cropRight;
    if (cropBottom != null) transform['cropBottom'] = cropBottom;

    await _obs.sceneItems.setSceneItemTransform(
      sceneName: sceneName,
      sceneItemId: sceneItemId,
      sceneItemTransform: transform,
    );
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Inputs
  // ---------------------------------------------------------------------------

  /// Lists all inputs, optionally filtered by input kind.
  @Tool(
    name: 'inputs_list',
    description:
        'List all inputs in OBS. Provide inputKind to filter to a single kind.',
  )
  Future<List<Map<String, dynamic>>> inputsList({String? inputKind}) async {
    final inputs = await _obs.inputs.getInputList(inputKind);
    return inputs.map((e) => e.toJson()).toList();
  }

  /// Lists the available input kinds on the OBS instance.
  @Tool(
    name: 'inputs_kind_list',
    description: 'Return the list of available input kinds on this OBS.',
  )
  Future<List<String>> inputsKindList({bool? unversioned}) =>
      _obs.inputs.getInputKindList(unversioned ?? false);

  /// Returns the names of the "special" inputs (mic/aux).
  @Tool(
    name: 'inputs_special',
    description: 'Return the names of OBS special inputs (mic/aux/etc.).',
  )
  Future<Map<String, dynamic>> inputsSpecial() async =>
      (await _obs.inputs.getSpecialInputs()).toJson();

  /// Returns whether an input is muted.
  @Tool(
    name: 'inputs_get_mute',
    description: 'Return whether an input is currently muted.',
  )
  Future<bool> inputsGetMute(String inputName) =>
      _obs.inputs.getInputMute(inputName);

  /// Sets the mute state of an input.
  @Tool(
    name: 'inputs_set_mute',
    description: 'Mute or unmute an input (by name or uuid).',
  )
  Future<Map<String, dynamic>> inputsSetMute({
    String? inputName,
    String? inputUuid,
    required bool inputMuted,
  }) async {
    await _obs.inputs.setInputMute(
      inputName: inputName,
      inputUuid: inputUuid,
      inputMuted: inputMuted,
    );
    return _ok;
  }

  /// Toggles the mute state of an input and returns the new value.
  @Tool(
    name: 'inputs_toggle_mute',
    description: 'Toggle mute on an input and return the new muted state.',
  )
  Future<bool> inputsToggleMute({String? inputName, String? inputUuid}) =>
      _obs.inputs.toggleInputMute(inputName: inputName, inputUuid: inputUuid);

  /// Returns volume (mul + dB) for an input.
  @Tool(
    name: 'inputs_get_volume',
    description: 'Return the volume of an input as both multiplier and dB.',
  )
  Future<Map<String, dynamic>> inputsGetVolume({
    String? inputName,
    String? inputUuid,
  }) async {
    final response = await _obs.inputs.getInputVolume(
      inputName: inputName,
      inputUuid: inputUuid,
    );
    return response.toJson();
  }

  /// Returns the current settings JSON for an input.
  @Tool(
    name: 'inputs_get_settings',
    description: 'Return the current settings payload for an input.',
  )
  Future<Map<String, dynamic>> inputsGetSettings({
    String? inputName,
    String? inputUuid,
  }) async {
    final response = await _obs.inputs.getInputSettings(
      inputName: inputName,
      inputUuid: inputUuid,
    );
    return response.toJson();
  }

  /// Overwrites the settings JSON for an input.
  @Tool(
    name: 'inputs_set_settings',
    description: 'Overwrite or merge an input settings payload.',
  )
  Future<Map<String, dynamic>> inputsSetSettings({
    String? inputName,
    String? inputUuid,
    required Map<String, dynamic> inputSettings,
    bool? overlay,
  }) async {
    await _obs.inputs.setInputSettings(
      inputName: inputName,
      inputUuid: inputUuid,
      inputSettings: inputSettings,
      overlay: overlay ?? true,
    );
    return _ok;
  }

  /// Renames an input.
  @Tool(name: 'inputs_set_name', description: 'Rename an input.')
  Future<Map<String, dynamic>> inputsSetName({
    String? inputName,
    String? inputUuid,
    required String newInputName,
  }) async {
    await _obs.inputs.setInputName(
      inputName: inputName,
      inputUuid: inputUuid,
      newInputName: newInputName,
    );
    return _ok;
  }

  /// Creates an input inside a scene.
  @Tool(
    name: 'inputs_create',
    description: 'Create a new input as a scene item inside a scene.',
  )
  Future<Map<String, dynamic>> inputsCreate({
    String? sceneName,
    String? sceneUuid,
    required String inputName,
    required String inputKind,
    Map<String, dynamic>? inputSettings,
    bool? sceneItemEnabled,
  }) async {
    final response = await _obs.inputs.createInput(
      sceneName: sceneName,
      sceneUuid: sceneUuid,
      inputName: inputName,
      inputKind: inputKind,
      inputSettings: inputSettings,
      sceneItemEnabled: sceneItemEnabled,
    );
    return response.toJson();
  }

  /// Removes an input.
  @Tool(name: 'inputs_remove', description: 'Delete an input by name or uuid.')
  Future<Map<String, dynamic>> inputsRemove({
    String? inputName,
    String? inputUuid,
  }) async {
    await _obs.inputs.removeInput(inputName: inputName, inputUuid: inputUuid);
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Stream
  // ---------------------------------------------------------------------------

  /// Returns the live streaming status (active / reconnecting / bytes).
  @Tool(
    name: 'stream_status',
    description: 'Return the current streaming status.',
  )
  Future<Map<String, dynamic>> streamStatus() async =>
      (await _obs.stream.getStreamStatus()).toJson();

  /// Starts streaming.
  @Tool(name: 'stream_start', description: 'Start the active streaming output.')
  Future<Map<String, dynamic>> streamStart() async {
    await _obs.stream.start();
    return _ok;
  }

  /// Stops streaming.
  @Tool(name: 'stream_stop', description: 'Stop the active streaming output.')
  Future<Map<String, dynamic>> streamStop() async {
    await _obs.stream.stop();
    return _ok;
  }

  /// Toggles streaming and returns the new active state.
  @Tool(
    name: 'stream_toggle',
    description: 'Toggle streaming. Returns the resulting active state.',
  )
  Future<bool> streamToggle() => _obs.stream.toggle();

  /// Sends a caption to the live stream (requires caption-capable output).
  @Tool(
    name: 'stream_send_caption',
    description: 'Send a caption line to the active stream.',
  )
  Future<Map<String, dynamic>> streamSendCaption(String captionText) async {
    await _obs.stream.sendStreamCaption(captionText);
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Record
  // ---------------------------------------------------------------------------

  /// Returns recording status (active / paused / duration / bytes).
  @Tool(
    name: 'record_status',
    description: 'Return the current recording status.',
  )
  Future<Map<String, dynamic>> recordStatus() async =>
      (await _obs.record.getRecordStatus()).toJson();

  /// Starts recording.
  @Tool(name: 'record_start', description: 'Start a new recording.')
  Future<Map<String, dynamic>> recordStart() async {
    await _obs.record.start();
    return _ok;
  }

  /// Stops recording and returns the output file path.
  @Tool(
    name: 'record_stop',
    description:
        'Stop the current recording and return the resulting file path.',
  )
  Future<String> recordStop() => _obs.record.stop();

  /// Toggles recording.
  @Tool(name: 'record_toggle', description: 'Toggle recording on/off.')
  Future<Map<String, dynamic>> recordToggle() async {
    await _obs.record.toggle();
    return _ok;
  }

  /// Pauses a recording in progress.
  @Tool(name: 'record_pause', description: 'Pause the active recording.')
  Future<Map<String, dynamic>> recordPause() async {
    await _obs.record.pause();
    return _ok;
  }

  /// Resumes a paused recording.
  @Tool(name: 'record_resume', description: 'Resume a paused recording.')
  Future<Map<String, dynamic>> recordResume() async {
    await _obs.record.resume();
    return _ok;
  }

  /// Toggles pause state on a recording.
  @Tool(
    name: 'record_toggle_pause',
    description: 'Toggle pause state of the active recording.',
  )
  Future<Map<String, dynamic>> recordTogglePause() async {
    await _obs.record.togglePause();
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Outputs (virtual cam, replay buffer, arbitrary outputs)
  // ---------------------------------------------------------------------------

  /// Returns whether the virtual camera output is active.
  @Tool(
    name: 'outputs_virtual_cam_status',
    description: 'Return whether the virtual camera output is active.',
  )
  Future<bool> outputsVirtualCamStatus() => _obs.outputs.getVirtualCamStatus();

  /// Toggles the virtual camera and returns the new state.
  @Tool(
    name: 'outputs_virtual_cam_toggle',
    description: 'Toggle the virtual camera output. Returns new state.',
  )
  Future<bool> outputsVirtualCamToggle() => _obs.outputs.toggleVirtualCam();

  /// Starts the virtual camera output.
  @Tool(
    name: 'outputs_virtual_cam_start',
    description: 'Start the virtual camera output.',
  )
  Future<Map<String, dynamic>> outputsVirtualCamStart() async {
    await _obs.outputs.startVirtualCam();
    return _ok;
  }

  /// Stops the virtual camera output.
  @Tool(
    name: 'outputs_virtual_cam_stop',
    description: 'Stop the virtual camera output.',
  )
  Future<Map<String, dynamic>> outputsVirtualCamStop() async {
    await _obs.outputs.stopVirtualCam();
    return _ok;
  }

  /// Returns whether the replay buffer is active.
  @Tool(
    name: 'outputs_replay_buffer_status',
    description: 'Return whether the replay buffer is currently active.',
  )
  Future<bool> outputsReplayBufferStatus() =>
      _obs.outputs.getReplayBufferStatus();

  /// Toggles the replay buffer.
  @Tool(
    name: 'outputs_replay_buffer_toggle',
    description: 'Toggle the replay buffer. Returns the new active state.',
  )
  Future<bool> outputsReplayBufferToggle() => _obs.outputs.toggleReplayBuffer();

  /// Starts the replay buffer.
  @Tool(
    name: 'outputs_replay_buffer_start',
    description: 'Start the replay buffer.',
  )
  Future<Map<String, dynamic>> outputsReplayBufferStart({
    String? outputName,
  }) async {
    await _obs.outputs.startReplayBuffer(outputName ?? '');
    return _ok;
  }

  /// Stops the replay buffer.
  @Tool(
    name: 'outputs_replay_buffer_stop',
    description: 'Stop the replay buffer.',
  )
  Future<Map<String, dynamic>> outputsReplayBufferStop({
    String? outputName,
  }) async {
    await _obs.outputs.stopReplayBuffer(outputName ?? '');
    return _ok;
  }

  /// Saves the contents of the replay buffer to disk.
  @Tool(
    name: 'outputs_replay_buffer_save',
    description: 'Flush the replay buffer contents to a replay file.',
  )
  Future<Map<String, dynamic>> outputsReplayBufferSave({
    String? outputName,
  }) async {
    await _obs.outputs.saveReplayBuffer(outputName ?? '');
    return _ok;
  }

  /// Toggles a named output and returns the new state.
  @Tool(
    name: 'outputs_toggle',
    description: 'Toggle a named OBS output. Returns the new active state.',
  )
  Future<bool> outputsToggle(String outputName) =>
      _obs.outputs.toggleOutput(outputName);

  /// Starts a named output.
  @Tool(name: 'outputs_start', description: 'Start a named OBS output.')
  Future<Map<String, dynamic>> outputsStart(String outputName) async {
    await _obs.outputs.start(outputName);
    return _ok;
  }

  /// Stops a named output.
  @Tool(name: 'outputs_stop', description: 'Stop a named OBS output.')
  Future<Map<String, dynamic>> outputsStop(String outputName) async {
    await _obs.outputs.stop(outputName);
    return _ok;
  }

  // ---------------------------------------------------------------------------
  // Config
  // ---------------------------------------------------------------------------

  /// Returns the currently configured recording directory.
  @Tool(
    name: 'config_record_directory',
    description: 'Return the current recording directory.',
  )
  Future<String> configRecordDirectory() async =>
      (await _obs.config.getRecordDirectory()).recordDirectory;

  /// Returns the active streaming service name + settings.
  @Tool(
    name: 'config_stream_service_settings',
    description: 'Return the active streaming service name + settings.',
  )
  Future<Map<String, dynamic>> configStreamServiceSettings() async =>
      (await _obs.config.getStreamServiceSettings()).toJson();

  // ---------------------------------------------------------------------------
  // UI / Studio Mode
  // ---------------------------------------------------------------------------

  /// Returns whether studio mode is enabled.
  @Tool(
    name: 'ui_studio_mode_enabled',
    description: 'Return whether OBS studio mode is currently enabled.',
  )
  Future<bool> uiStudioModeEnabled() => _obs.ui.getStudioModeEnabled();

  /// Enables or disables studio mode.
  @Tool(
    name: 'ui_set_studio_mode',
    description: 'Enable or disable OBS studio mode.',
  )
  Future<Map<String, dynamic>> uiSetStudioMode(bool enabled) async {
    await _obs.ui.setStudioModeEnabled(enabled);
    return _ok;
  }

  /// Opens the properties dialog for the given input.
  @Tool(
    name: 'ui_open_input_properties',
    description:
        'Open the properties dialog window in the OBS UI for the given input.',
  )
  Future<Map<String, dynamic>> uiOpenInputProperties(String inputName) async {
    await _obs.ui.openInputPropertiesDialog(inputName);
    return _ok;
  }

  /// Opens the filters dialog for the given input.
  @Tool(
    name: 'ui_open_input_filters',
    description: 'Open the filters dialog in the OBS UI for the given input.',
  )
  Future<Map<String, dynamic>> uiOpenInputFilters(String inputName) async {
    await _obs.ui.openInputFiltersDialog(inputName);
    return _ok;
  }

  /// Opens the interact window for the given input (browser sources etc.).
  @Tool(
    name: 'ui_open_input_interact',
    description: 'Open the interact dialog in the OBS UI for the given input.',
  )
  Future<Map<String, dynamic>> uiOpenInputInteract(String inputName) async {
    await _obs.ui.openInputInteractDialog(inputName);
    return _ok;
  }

  /// Returns the list of monitors that can host a projector.
  @Tool(
    name: 'ui_monitor_list',
    description: 'Return the list of connected monitors.',
  )
  Future<List<Map<String, dynamic>>> uiMonitorList() async {
    final monitors = await _obs.ui.getMonitorList();
    return monitors.map((e) => e.toJson()).toList();
  }

  // ---------------------------------------------------------------------------
  // Transitions
  // ---------------------------------------------------------------------------

  /// Triggers the studio-mode preview→program transition.
  @Tool(
    name: 'transitions_trigger_studio',
    description:
        'Trigger the studio-mode transition from the preview scene to program.',
  )
  Future<Map<String, dynamic>> transitionsTriggerStudio() async {
    await _obs.send('TriggerStudioModeTransition');
    return _ok;
  }
}
