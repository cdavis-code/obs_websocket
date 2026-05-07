/// JS-adapted MCP server with tool registration and dispatch.
///
/// This is a port of `packages/obs_mcp/lib/src/obs_mcp_server.mcp.dart` that
/// removes dart:io dependencies. Code execution uses `eval` in the current
/// Node.js process context (NOT sandboxed).
///
/// All tool registrations and dispatch logic are preserved from the original.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';

import 'node_interop.dart';
import 'obs_mcp_server_js.dart' as obs_mcp_server;

@JS('globalThis')
external JSObject get _jsGlobalThis;

/// Helper to create a JS function from a string body.
JSFunction _newJsFunction(String body) {
  final code = 'new Function(${jsonEncode(body)})';
  return _jsEval(code.toJS) as JSFunction;
}

@JS('eval')
external JSAny _jsEval(JSString code);

base class MCPServerWithToolsJs extends MCPServer with ToolsSupport {
  static bool get _logErrors => getEnvVar('OBS_MCP_DEBUG') == '1';

  MCPServerWithToolsJs(StreamChannel<String> channel)
    : super.fromStreamChannel(
        channel,
        implementation: Implementation(
          name: 'obs-mcp-server',
          version: '5.7.1',
        ),
        instructions:
            'OBS Studio MCP server — control OBS via obs-websocket v5.x. '
            'Use the search tool to discover available tools, then call them directly '
            'or use the execute tool to run JavaScript code with access to all tools.',
      ) {
    registerTool(
      Tool(
        name: 'search',
        description:
            'Search for available tools by name or description. Returns matching tools with their parameter information. Use this to discover available tools before calling execute.',
        inputSchema: Schema.object(
          properties: {
            'query': Schema.string(
              description:
                  'Search terms. Space-separated terms are AND-matched against tool names and descriptions (case-insensitive).',
            ),
            'detail_level': UntitledSingleSelectEnumSchema(
              description:
                  'Level of detail: "brief" (name + description), "detailed" (+ parameter names/types/required), "full" (+ complete parameter schemas).',
              values: ['brief', 'detailed', 'full'],
            ),
          },
          required: ['query'],
        ),
      ),
      _search,
    );
    registerTool(
      Tool(
        name: 'execute',
        description:
            'Execute JavaScript code with access to MCP tool functions. Use call_tool(name, params) to call any tool by name, or use external_<toolName>(args) convenience wrappers. Use the search tool first to discover available tools and their signatures. All calls are async - use await for sequential calls and Promise.all() for parallel calls. Return a value to include it in the result.',
        inputSchema: Schema.object(
          properties: {
            'code': Schema.string(description: 'JavaScript code to execute.'),
          },
          required: ['code'],
        ),
      ),
      _execute,
    );
    if (getEnvVar('OBS_MCP_DEBUG') == '1') {
      logError(
        '[obs-mcp-js] MCPServerWithToolsJs constructor: tools registered',
      );
    }
  }

  FutureOr<CallToolResult> _obs_connect(CallToolRequest request) async {
    try {
      final url = request.arguments!['url'] as String;
      final password = request.arguments?['password'] as String?;
      final timeoutSeconds = request.arguments?['timeoutSeconds'] as int?;
      final autoReconnect = request.arguments?['autoReconnect'] as bool?;
      final result = await obs_mcp_server.ObsMcpServer().connect(
        url: url,
        password: password,
        timeoutSeconds: timeoutSeconds,
        autoReconnect: autoReconnect,
      );
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_connect', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_disconnect(CallToolRequest request) async {
    try {
      final result = await obs_mcp_server.ObsMcpServer().disconnect();
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_disconnect', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_is_connected(CallToolRequest request) {
    try {
      final result = obs_mcp_server.ObsMcpServer().isConnected();
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_is_connected', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_send_raw(CallToolRequest request) async {
    try {
      final requestType = request.arguments!['requestType'] as String;
      final requestData = request.arguments?['requestData'];
      final result = await obs_mcp_server.ObsMcpServer().sendRaw(
        requestType: requestType,
        requestData: requestData,
      );
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_send_raw', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_general_version(CallToolRequest request) async {
    try {
      final result = await obs_mcp_server.ObsMcpServer().generalVersion();
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_general_version', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_general_stats(CallToolRequest request) async {
    try {
      final result = await obs_mcp_server.ObsMcpServer().generalStats();
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_general_stats', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_general_hotkeys(CallToolRequest request) async {
    try {
      final result = await obs_mcp_server.ObsMcpServer().generalHotkeys();
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_general_hotkeys', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_general_trigger_hotkey(
    CallToolRequest request,
  ) async {
    try {
      final hotkeyName = request.arguments!['hotkeyName'] as String;
      final result = await obs_mcp_server.ObsMcpServer().generalTriggerHotkey(
        hotkeyName,
      );
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_general_trigger_hotkey', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_general_sleep(CallToolRequest request) async {
    try {
      final sleepMillis = request.arguments?['sleepMillis'] as int?;
      final sleepFrames = request.arguments?['sleepFrames'] as int?;
      final result = await obs_mcp_server.ObsMcpServer().generalSleep(
        sleepMillis: sleepMillis,
        sleepFrames: sleepFrames,
      );
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_general_sleep', e, st);
    }
  }

  FutureOr<CallToolResult> _obs_general_broadcast_custom_event(
    CallToolRequest request,
  ) async {
    try {
      final eventData = request.arguments!['eventData'];
      final result = await obs_mcp_server.ObsMcpServer()
          .generalBroadcastCustomEvent(eventData);
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError('obs_general_broadcast_custom_event', e, st);
    }
  }

  // --- Remaining tool handlers use a dispatch pattern for brevity ---

  CallToolResult _handleError(String name, Object e, StackTrace st) {
    if (_logErrors) {
      logError('[easy_api] $name: $e');
      logError('$st');
    }
    return CallToolResult(
      content: [
        TextContent(text: 'An error occurred while processing the request.'),
      ],
      isError: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Search tool
  // ---------------------------------------------------------------------------

  static const _codeModeToolSpecs = <Map<String, dynamic>>[
    // --- Connection ---
    {
      'name': 'obs_connect',
      'description':
          'Connect to an OBS WebSocket server (ws:// or wss://) and authenticate.',
      'parameters': [
        {'name': 'url', 'type': 'string', 'required': true},
        {'name': 'password', 'type': 'string', 'required': false},
        {'name': 'timeoutSeconds', 'type': 'number', 'required': false},
        {'name': 'autoReconnect', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_disconnect',
      'description': 'Close the active OBS WebSocket connection.',
      'parameters': [],
    },
    {
      'name': 'obs_is_connected',
      'description': 'Return whether a live OBS WebSocket connection is held.',
      'parameters': [],
    },
    {
      'name': 'obs_connection_status',
      'description':
          'Return the current OBS WebSocket connection state plus negotiated RPC version.',
      'parameters': [],
    },
    {
      'name': 'obs_connection_ping',
      'description':
          'Round-trip a GetVersion request and return latency in ms.',
      'parameters': [],
    },
    {
      'name': 'obs_send_raw',
      'description':
          'Send a raw OBS WebSocket request and return the response payload.',
      'parameters': [
        {'name': 'requestType', 'type': 'string', 'required': true},
        {'name': 'requestData', 'type': 'object', 'required': false},
      ],
    },
    // --- General ---
    {
      'name': 'obs_general_version',
      'description': 'Return OBS Studio + obs-websocket version information.',
      'parameters': [],
    },
    {
      'name': 'obs_general_stats',
      'description': 'Return OBS runtime statistics (cpu, memory, frame rate).',
      'parameters': [],
    },
    {
      'name': 'obs_general_hotkeys',
      'description': 'Return the names of every registered hotkey in OBS.',
      'parameters': [],
    },
    {
      'name': 'obs_general_trigger_hotkey',
      'description': 'Trigger a hotkey by its registered name.',
      'parameters': [
        {'name': 'hotkeyName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_general_trigger_hotkey_by_key',
      'description':
          'Trigger a hotkey using a key sequence (e.g., Ctrl+Shift+A).',
      'parameters': [
        {'name': 'keyId', 'type': 'string', 'required': true},
        {'name': 'shift', 'type': 'boolean', 'required': false},
        {'name': 'control', 'type': 'boolean', 'required': false},
        {'name': 'alt', 'type': 'boolean', 'required': false},
        {'name': 'command', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_general_sleep',
      'description':
          'Sleep for a duration in milliseconds or frames (executed server-side).',
      'parameters': [
        {'name': 'sleepMillis', 'type': 'number', 'required': false},
        {'name': 'sleepFrames', 'type': 'number', 'required': false},
      ],
    },
    {
      'name': 'obs_general_broadcast_custom_event',
      'description': 'Broadcast a custom JSON event to all connected clients.',
      'parameters': [
        {'name': 'eventData', 'type': 'object', 'required': true},
      ],
    },
    {
      'name': 'obs_general_call_vendor_request',
      'description':
          'Call a request registered to a third-party vendor/plugin.',
      'parameters': [
        {'name': 'vendorName', 'type': 'string', 'required': true},
        {'name': 'requestType', 'type': 'string', 'required': true},
        {'name': 'requestData', 'type': 'object', 'required': false},
      ],
    },
    // --- Scenes ---
    {
      'name': 'obs_scenes_list',
      'description':
          'Return all scenes plus the current program and preview scene.',
      'parameters': [],
    },
    {
      'name': 'obs_scenes_group_list',
      'description': 'Return the names of all groups in OBS.',
      'parameters': [],
    },
    {
      'name': 'obs_scenes_get_current_program',
      'description':
          'Return the name of the scene currently on the program bus.',
      'parameters': [],
    },
    {
      'name': 'obs_scenes_set_current_program',
      'description': 'Set the program scene to the given sceneName.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_scenes_get_current_preview',
      'description': 'Return the name of the preview scene (studio mode only).',
      'parameters': [],
    },
    {
      'name': 'obs_scenes_set_current_preview',
      'description': 'Set the preview scene (studio mode only).',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_scenes_create',
      'description': 'Create a new scene with the given name.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
      ],
    },
    // --- Scene Items ---
    {
      'name': 'obs_scene_items_list',
      'description': 'List the scene items (sources) contained in a scene.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_group_list',
      'description': 'List the scene items contained in a group.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_get_id',
      'description':
          'Return the numeric sceneItemId for a source placed in a given scene.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sourceName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_get_enabled',
      'description':
          'Return whether a scene item is currently enabled (visible).',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_set_enabled',
      'description': 'Show or hide a scene item by id.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
        {'name': 'sceneItemEnabled', 'type': 'boolean', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_get_locked',
      'description': 'Return whether a scene item is locked (uneditable).',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_set_locked',
      'description': 'Lock or unlock a scene item by id.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
        {'name': 'sceneItemLocked', 'type': 'boolean', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_get_transform',
      'description':
          'Return the transform properties of a scene item (position, scale, rotation, crop, bounds).',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_set_transform',
      'description':
          'Set the transform properties of a scene item. Only provide the fields you want to change.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
        {'name': 'positionX', 'type': 'number', 'required': false},
        {'name': 'positionY', 'type': 'number', 'required': false},
        {'name': 'scaleX', 'type': 'number', 'required': false},
        {'name': 'scaleY', 'type': 'number', 'required': false},
        {'name': 'rotation', 'type': 'number', 'required': false},
        {'name': 'cropLeft', 'type': 'number', 'required': false},
        {'name': 'cropTop', 'type': 'number', 'required': false},
        {'name': 'cropRight', 'type': 'number', 'required': false},
        {'name': 'cropBottom', 'type': 'number', 'required': false},
        {'name': 'alignment', 'type': 'number', 'required': false},
        {'name': 'boundsType', 'type': 'string', 'required': false},
        {'name': 'boundsAlignment', 'type': 'number', 'required': false},
        {'name': 'boundsWidth', 'type': 'number', 'required': false},
        {'name': 'boundsHeight', 'type': 'number', 'required': false},
      ],
    },
    {
      'name': 'obs_scene_items_create',
      'description': 'Add an existing source as a new scene item in a scene.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'sceneItemEnabled', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_scene_items_duplicate',
      'description':
          'Duplicate a scene item, copying it to the same or a different scene.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
        {'name': 'destinationSceneName', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_scene_items_remove',
      'description':
          'Remove a scene item from a scene (does not delete the source).',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_get_source',
      'description': 'Return the source name for a given scene item.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': false},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_get_private_settings',
      'description': 'Return the private settings of a scene item.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': false},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_set_private_settings',
      'description': 'Set the private settings of a scene item.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': false},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
        {'name': 'sceneItemSettings', 'type': 'object', 'required': true},
      ],
    },
    {
      'name': 'obs_scene_items_animate_transform',
      'description': 'Animate a scene item transform over time with easing.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': true},
        {'name': 'sceneItemId', 'type': 'number', 'required': true},
        {'name': 'durationMs', 'type': 'number', 'required': true},
        {'name': 'targetPositionX', 'type': 'number', 'required': false},
        {'name': 'targetPositionY', 'type': 'number', 'required': false},
        {'name': 'targetScaleX', 'type': 'number', 'required': false},
        {'name': 'targetScaleY', 'type': 'number', 'required': false},
        {'name': 'targetRotation', 'type': 'number', 'required': false},
        {'name': 'frameRate', 'type': 'number', 'required': false},
        {'name': 'easing', 'type': 'string', 'required': false},
        {'name': 'restoreOnComplete', 'type': 'boolean', 'required': false},
      ],
    },
    // --- Inputs ---
    {
      'name': 'obs_inputs_list',
      'description':
          'List all inputs in OBS. Provide inputKind to filter to a single kind.',
      'parameters': [
        {'name': 'inputKind', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_kind_list',
      'description': 'Return the list of available input kinds on this OBS.',
      'parameters': [
        {'name': 'unversioned', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_special',
      'description': 'Return the names of OBS special inputs (mic/aux/etc.).',
      'parameters': [],
    },
    {
      'name': 'obs_inputs_get_mute',
      'description': 'Return whether an input is currently muted.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_set_mute',
      'description': 'Mute or unmute an input (by name or uuid).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'inputMuted', 'type': 'boolean', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_toggle_mute',
      'description': 'Toggle mute on an input and return the new muted state.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_get_volume',
      'description': 'Return the volume of an input as both multiplier and dB.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_volume',
      'description': 'Set the volume of an input (0.0-1.0 multiplier).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'inputVolume', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_settings',
      'description': 'Return the current settings payload for an input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_settings',
      'description': 'Overwrite or merge an input settings payload.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'inputSettings', 'type': 'object', 'required': true},
        {'name': 'overlay', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_name',
      'description': 'Rename an input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'newInputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_create',
      'description': 'Create a new input as a scene item inside a scene.',
      'parameters': [
        {'name': 'sceneName', 'type': 'string', 'required': false},
        {'name': 'inputName', 'type': 'string', 'required': true},
        {'name': 'inputKind', 'type': 'string', 'required': true},
        {'name': 'inputSettings', 'type': 'object', 'required': false},
        {'name': 'sceneItemEnabled', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_remove',
      'description': 'Delete an input by name or uuid.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_get_default_settings',
      'description': 'Return the default settings for a given input kind.',
      'parameters': [
        {'name': 'inputKind', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_audio_balance',
      'description': 'Return the audio balance (left-right) of an input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_audio_balance',
      'description':
          'Set the audio balance of an input (0.0 = left, 1.0 = right, 0.5 = center).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'inputAudioBalance', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_audio_sync_offset',
      'description':
          'Return the audio sync offset of an input in milliseconds.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_audio_sync_offset',
      'description': 'Set the audio sync offset of an input in milliseconds.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'inputAudioSyncOffset', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_audio_monitor_type',
      'description':
          'Return the audio monitor type of an input (none, monitor only, monitor and output).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_audio_monitor_type',
      'description':
          'Set the audio monitor type of an input (0 = none, 1 = monitor only, 2 = monitor and output).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'monitorType', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_audio_tracks',
      'description': 'Return the audio track bitmask of an input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_audio_tracks',
      'description':
          'Set the audio tracks of an input (bitmask: 1=track1, 2=track2, 4=track3, etc.).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'inputAudioTracks', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_deinterlace_mode',
      'description': 'Return the deinterlace mode of an input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_deinterlace_mode',
      'description':
          'Set the deinterlace mode of an input (disable, discard, retro, blend, etc.).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'mode', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_deinterlace_field_order',
      'description': 'Return the deinterlace field order of an input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_inputs_set_deinterlace_field_order',
      'description':
          'Set the deinterlace field order of an input (top, bottom).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'fieldOrder', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_get_properties_list_items',
      'description':
          "Return the items of a list property from an input's properties dialog.",
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'propertyName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_inputs_press_properties_button',
      'description': "Press a button property in an input's properties dialog.",
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'propertyName', 'type': 'string', 'required': true},
      ],
    },
    // --- Stream ---
    {
      'name': 'obs_stream_status',
      'description': 'Return the current streaming status.',
      'parameters': [],
    },
    {
      'name': 'obs_stream_start',
      'description': 'Start the active streaming output.',
      'parameters': [],
    },
    {
      'name': 'obs_stream_stop',
      'description': 'Stop the active streaming output.',
      'parameters': [],
    },
    {
      'name': 'obs_stream_toggle',
      'description': 'Toggle streaming. Returns the resulting active state.',
      'parameters': [],
    },
    {
      'name': 'obs_stream_send_caption',
      'description': 'Send a caption line to the active stream.',
      'parameters': [
        {'name': 'captionText', 'type': 'string', 'required': true},
      ],
    },
    // --- Record ---
    {
      'name': 'obs_record_status',
      'description': 'Return the current recording status.',
      'parameters': [],
    },
    {
      'name': 'obs_record_start',
      'description': 'Start a new recording.',
      'parameters': [],
    },
    {
      'name': 'obs_record_stop',
      'description':
          'Stop the current recording and return the resulting file path.',
      'parameters': [],
    },
    {
      'name': 'obs_record_toggle',
      'description': 'Toggle recording on/off.',
      'parameters': [],
    },
    {
      'name': 'obs_record_pause',
      'description': 'Pause the active recording.',
      'parameters': [],
    },
    {
      'name': 'obs_record_resume',
      'description': 'Resume a paused recording.',
      'parameters': [],
    },
    {
      'name': 'obs_record_toggle_pause',
      'description': 'Toggle pause state of the active recording.',
      'parameters': [],
    },
    // --- Outputs ---
    {
      'name': 'obs_outputs_list',
      'description': 'Return the list of all available outputs in OBS.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_get_status',
      'description': 'Return the status of a named output.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_outputs_get_settings',
      'description': 'Return the settings of a named output.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_outputs_set_settings',
      'description': 'Set the settings of a named output.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': true},
        {'name': 'outputSettings', 'type': 'object', 'required': true},
      ],
    },
    {
      'name': 'obs_outputs_virtual_cam_status',
      'description': 'Return whether the virtual camera output is active.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_virtual_cam_toggle',
      'description': 'Toggle the virtual camera output. Returns new state.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_virtual_cam_start',
      'description': 'Start the virtual camera output.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_virtual_cam_stop',
      'description': 'Stop the virtual camera output.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_replay_buffer_status',
      'description': 'Return whether the replay buffer is currently active.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_replay_buffer_toggle',
      'description': 'Toggle the replay buffer. Returns the new active state.',
      'parameters': [],
    },
    {
      'name': 'obs_outputs_replay_buffer_start',
      'description': 'Start the replay buffer.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_outputs_replay_buffer_stop',
      'description': 'Stop the replay buffer.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_outputs_replay_buffer_save',
      'description': 'Flush the replay buffer contents to a replay file.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_outputs_toggle',
      'description': 'Toggle a named OBS output. Returns the new active state.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_outputs_start',
      'description': 'Start a named OBS output.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_outputs_stop',
      'description': 'Stop a named OBS output.',
      'parameters': [
        {'name': 'outputName', 'type': 'string', 'required': true},
      ],
    },
    // --- Config ---
    {
      'name': 'obs_config_record_directory',
      'description': 'Return the current recording directory.',
      'parameters': [],
    },
    {
      'name': 'obs_config_stream_service_settings',
      'description': 'Return the active streaming service name + settings.',
      'parameters': [],
    },
    // --- UI ---
    {
      'name': 'obs_ui_studio_mode_enabled',
      'description': 'Return whether OBS studio mode is currently enabled.',
      'parameters': [],
    },
    {
      'name': 'obs_ui_set_studio_mode',
      'description': 'Enable or disable OBS studio mode.',
      'parameters': [
        {'name': 'enabled', 'type': 'boolean', 'required': true},
      ],
    },
    {
      'name': 'obs_ui_open_input_properties',
      'description':
          'Open the properties dialog window in the OBS UI for the given input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_ui_open_input_filters',
      'description':
          'Open the filters dialog in the OBS UI for the given input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_ui_open_input_interact',
      'description':
          'Open the interact dialog in the OBS UI for the given input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_ui_monitor_list',
      'description': 'Return the list of connected monitors.',
      'parameters': [],
    },
    // --- Transitions ---
    {
      'name': 'obs_transitions_trigger_studio',
      'description':
          'Trigger the studio-mode transition from the preview scene to program.',
      'parameters': [],
    },
    {
      'name': 'obs_transitions_kind_list',
      'description': 'Return the list of all available transition kinds.',
      'parameters': [],
    },
    {
      'name': 'obs_transitions_scene_list',
      'description':
          'Return the list of all scene transitions configured in OBS.',
      'parameters': [],
    },
    {
      'name': 'obs_transitions_get_current',
      'description': 'Return information about the current scene transition.',
      'parameters': [],
    },
    {
      'name': 'obs_transitions_set_current',
      'description': 'Set the current scene transition by name.',
      'parameters': [
        {'name': 'transitionName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_transitions_set_duration',
      'description':
          'Set the duration of the current scene transition in milliseconds.',
      'parameters': [
        {'name': 'duration', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_transitions_get_cursor',
      'description':
          'Return the cursor position (0.0-1.0) of the current scene transition.',
      'parameters': [],
    },
    {
      'name': 'obs_transitions_set_settings',
      'description': 'Set the settings of the current scene transition.',
      'parameters': [
        {'name': 'transitionSettings', 'type': 'object', 'required': true},
        {'name': 'overlay', 'type': 'boolean', 'required': false},
      ],
    },
    {
      'name': 'obs_transitions_set_t_bar',
      'description': 'Set the T-Bar position (0.0-1.0). Requires Studio Mode.',
      'parameters': [
        {'name': 'position', 'type': 'number', 'required': true},
        {'name': 'release', 'type': 'boolean', 'required': false},
      ],
    },
    // --- Sources ---
    {
      'name': 'obs_sources_get_active',
      'description':
          'Return whether a source is active (shown in preview/program) and visible.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_sources_get_screenshot',
      'description': 'Get a Base64-encoded screenshot of a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'imageFormat', 'type': 'string', 'required': true},
        {'name': 'imageWidth', 'type': 'number', 'required': false},
        {'name': 'imageHeight', 'type': 'number', 'required': false},
        {
          'name': 'imageCompressionQuality',
          'type': 'number',
          'required': false,
        },
      ],
    },
    {
      'name': 'obs_sources_save_screenshot',
      'description':
          'Save a screenshot of a source to a file path on the filesystem.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filePath', 'type': 'string', 'required': true},
        {'name': 'imageFormat', 'type': 'string', 'required': true},
        {'name': 'imageWidth', 'type': 'number', 'required': false},
        {'name': 'imageHeight', 'type': 'number', 'required': false},
        {
          'name': 'imageCompressionQuality',
          'type': 'number',
          'required': false,
        },
      ],
    },
    {
      'name': 'obs_sources_get_private_settings',
      'description': 'Return the private settings of a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': false},
        {'name': 'sourceUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_sources_set_private_settings',
      'description': 'Set the private settings of a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': false},
        {'name': 'sourceUuid', 'type': 'string', 'required': false},
        {'name': 'sourceSettings', 'type': 'object', 'required': true},
      ],
    },
    // --- Media Inputs ---
    {
      'name': 'obs_media_inputs_get_status',
      'description':
          'Return the status of a media input (state, duration, cursor, etc.).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
      ],
    },
    {
      'name': 'obs_media_inputs_set_cursor',
      'description':
          'Set the cursor position (in milliseconds) of a media input.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'mediaCursor', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_media_inputs_offset_cursor',
      'description':
          'Offset the current cursor position of a media input by the specified milliseconds.',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'mediaCursorOffset', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_media_inputs_trigger_action',
      'description':
          'Trigger an action on a media input (play, pause, stop, restart, next, previous).',
      'parameters': [
        {'name': 'inputName', 'type': 'string', 'required': false},
        {'name': 'inputUuid', 'type': 'string', 'required': false},
        {'name': 'mediaAction', 'type': 'string', 'required': true},
      ],
    },
    // --- Filters ---
    {
      'name': 'obs_filters_kind_list',
      'description': 'Return the list of all available source filter kinds.',
      'parameters': [],
    },
    {
      'name': 'obs_filters_list',
      'description': 'Return the list of filters applied to a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_default_settings',
      'description': 'Return the default settings for a given filter kind.',
      'parameters': [
        {'name': 'filterKind', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_create',
      'description': 'Create a new filter and apply it to a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
        {'name': 'filterKind', 'type': 'string', 'required': true},
        {'name': 'filterSettings', 'type': 'object', 'required': false},
      ],
    },
    {
      'name': 'obs_filters_get',
      'description': 'Return information about a specific filter on a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_remove',
      'description': 'Remove a filter from a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_rename',
      'description': 'Rename a filter on a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
        {'name': 'newFilterName', 'type': 'string', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_set_enabled',
      'description': 'Enable or disable a filter on a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
        {'name': 'filterEnabled', 'type': 'boolean', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_set_index',
      'description': 'Set the index position (order) of a filter on a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
        {'name': 'filterIndex', 'type': 'number', 'required': true},
      ],
    },
    {
      'name': 'obs_filters_set_settings',
      'description': 'Set or merge the settings of a filter on a source.',
      'parameters': [
        {'name': 'sourceName', 'type': 'string', 'required': true},
        {'name': 'filterName', 'type': 'string', 'required': true},
        {'name': 'filterSettings', 'type': 'object', 'required': true},
        {'name': 'overlay', 'type': 'boolean', 'required': false},
      ],
    },
    // --- Canvases ---
    {
      'name': 'obs_canvases_list',
      'description':
          'Return the list of all canvases configured in OBS (v5.7.0+).',
      'parameters': [],
    },
    // --- Events ---
    {
      'name': 'obs_events_subscribe',
      'description': 'Update the active OBS event subscription mask.',
      'parameters': [
        {'name': 'mask', 'type': 'number', 'required': false},
        {'name': 'subscriptions', 'type': 'array', 'required': false},
      ],
    },
    {
      'name': 'obs_wait_for_event',
      'description': 'Wait for the next OBS event matching the given type.',
      'parameters': [
        {'name': 'eventType', 'type': 'string', 'required': true},
        {'name': 'timeoutMs', 'type': 'number', 'required': false},
      ],
    },
    // --- Utility ---
    {
      'name': 'obs_client_sleep',
      'description': 'Pause server-side for milliseconds (1-25000).',
      'parameters': [
        {'name': 'ms', 'type': 'number', 'required': true},
      ],
    },
  ];

  FutureOr<CallToolResult> _search(CallToolRequest request) async {
    try {
      final query = (request.arguments?['query'] as String?) ?? '';
      final detailLevel =
          (request.arguments?['detail_level'] as String?) ?? 'brief';
      final terms = query
          .toLowerCase()
          .split(' ')
          .where((t) => t.isNotEmpty)
          .toList();

      if (terms.isEmpty) {
        final results = _codeModeToolSpecs
            .map((tool) => _formatSearchResult(tool, detailLevel))
            .toList();
        return CallToolResult(
          content: [TextContent(text: jsonEncode(results))],
        );
      }

      final andMatches = _codeModeToolSpecs.where((tool) {
        final name = (tool['name'] as String).toLowerCase();
        final desc = (tool['description'] as String).toLowerCase();
        return terms.every(
          (term) => name.contains(term) || desc.contains(term),
        );
      }).toList();

      List<Map<String, dynamic>> matches;
      if (andMatches.isNotEmpty) {
        matches = andMatches;
      } else {
        final scored = _codeModeToolSpecs
            .map((tool) {
              final name = (tool['name'] as String).toLowerCase();
              final desc = (tool['description'] as String).toLowerCase();
              int score = 0;
              for (final term in terms) {
                if (name.contains(term) || desc.contains(term)) score++;
              }
              return MapEntry(tool, score);
            })
            .where((e) => e.value > 0)
            .toList();
        scored.sort((a, b) => b.value.compareTo(a.value));
        matches = scored.map((e) => e.key).toList();
      }

      final results = matches
          .map((tool) => _formatSearchResult(tool, detailLevel))
          .toList();
      return CallToolResult(content: [TextContent(text: jsonEncode(results))]);
    } catch (e, st) {
      return _handleError('_search', e, st);
    }
  }

  Map<String, dynamic> _formatSearchResult(
    Map<String, dynamic> tool,
    String detailLevel,
  ) {
    final name = tool['name'] as String;
    final desc = tool['description'] as String;
    final params = tool['parameters'] as List;
    if (detailLevel == 'brief') {
      return {'name': name, 'description': desc};
    }
    final paramInfo = params
        .map(
          (p) => {
            'name': p['name'],
            'type': p['type'],
            'required': p['required'],
          },
        )
        .toList();
    return {'name': name, 'description': desc, 'parameters': paramInfo};
  }

  // ---------------------------------------------------------------------------
  // Execute tool (code execution via eval in Node.js process)
  // ---------------------------------------------------------------------------

  FutureOr<CallToolResult> _execute(CallToolRequest request) async {
    try {
      final code = request.arguments!['code'] as String;
      final result = await _runCode(code, 30);
      return CallToolResult(content: [TextContent(text: result ?? 'null')]);
    } catch (e, st) {
      return _handleError('_execute', e, st);
    }
  }

  /// Runs JavaScript code in the current Node.js process context.
  /// Code has full access to the Node.js environment.
  /// This is NOT sandboxed execution — it uses `eval` via `new Function`.
  Future<String?> _runCode(String userCode, int timeoutSeconds) async {
    // Build the wrapper that provides call_tool() and external_* functions
    final wrapper = _buildJsWrapper(userCode);

    // Use eval via JS interop to run the code in the current context
    // The wrapper code communicates results back via a global callback
    final completer = Completer<String?>();

    // Set up a global callback for receiving the result
    final callbackName =
        '__mcp_sandbox_result_${DateTime.now().millisecondsSinceEpoch}';

    // Store a Dart callback that the JS code will invoke
    final doneCallback = ((JSString type, JSString data) {
      final typeStr = type.toDart;
      final dataStr = data.toDart;
      if (typeStr == 'done') {
        if (!completer.isCompleted)
          completer.complete(dataStr.isEmpty ? null : dataStr);
      } else if (typeStr == 'error') {
        if (!completer.isCompleted)
          completer.completeError(StateError('Code execution error: $dataStr'));
      }
    }).toJS;

    // Set the callback on globalThis
    final globalThis = _jsGlobalThis;
    globalThis.setProperty(callbackName.toJS, doneCallback);

    // Create the full script that wraps user code with IPC
    final fullScript =
        '''
(async () => {
  const __callback = globalThis['$callbackName'];
  let __callId = 0;

  async function call_tool(name, params) {
    // Direct dispatch through the Dart server
    const callId = String(++__callId);
    return new Promise((resolve, reject) => {
      globalThis['__mcp_pending_' + callId] = { resolve, reject };
      globalThis['__mcp_dispatch_tool']?.(name, JSON.stringify(params || {}), callId);
    });
  }

  // User code
  try {
    const __result = await (async () => {
      ${_wrapUserCode(userCode)}
    })();
    __callback('done', __result == null ? '' : (typeof __result === 'string' ? __result : JSON.stringify(__result)));
  } catch (e) {
    __callback('error', e.message || String(e));
  }
})();
''';

    // Set up tool dispatch callback
    final dispatchCallback =
        ((JSString toolName, JSString argsJson, JSString callId) {
          final name = toolName.toDart;
          final args = jsonDecode(argsJson.toDart) as Map<String, dynamic>;
          final id = callId.toDart;

          _dispatchCodeModeToolCall(name, args)
              .then((result) {
                final resultJson = result == null
                    ? 'null'
                    : (result is String ? result : jsonEncode(result));
                // Resolve the pending promise in JS
                final escapedResult = jsonEncode(resultJson);
                _evalJs(
                  "globalThis['__mcp_pending_$id']?.resolve($escapedResult)",
                );
              })
              .catchError((e) {
                final escaped = jsonEncode(e.toString());
                _evalJs(
                  "globalThis['__mcp_pending_$id']?.reject(new Error($escaped))",
                );
              });
        }).toJS;

    globalThis.setProperty('__mcp_dispatch_tool'.toJS, dispatchCallback);

    // Execute the script
    _evalJs(fullScript);

    // Wait for result with timeout
    try {
      final result = await completer.future.timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () => throw StateError(
          'Code execution timed out after $timeoutSeconds seconds',
        ),
      );
      return result;
    } finally {
      // Cleanup
      globalThis.setProperty(callbackName.toJS, null);
      globalThis.setProperty('__mcp_dispatch_tool'.toJS, null);
    }
  }

  String _wrapUserCode(String userCode) {
    final trimmed = userCode.trim();
    final isExpressionLike =
        trimmed.startsWith('(') || trimmed.startsWith('await ');
    final alreadyHasReturn = trimmed.startsWith('return ');
    if (isExpressionLike && !alreadyHasReturn) return 'return $userCode';
    return userCode;
  }

  String _buildJsWrapper(String userCode) =>
      userCode; // Unused in JS-native approach

  // ---------------------------------------------------------------------------
  // Tool dispatch (for code mode)
  // ---------------------------------------------------------------------------

  dynamic _dispatchCodeModeToolCall(
    String toolName,
    Map<String, dynamic> args,
  ) async {
    final request = CallToolRequest(name: toolName, arguments: args);
    CallToolResult result;
    switch (toolName) {
      case 'search':
        result = await _search(request);
        break;
      case 'obs_connect':
        result = await _obs_connect(request);
        break;
      case 'obs_disconnect':
        result = await _obs_disconnect(request);
        break;
      case 'obs_is_connected':
        result = await _obs_is_connected(request);
        break;
      case 'obs_send_raw':
        result = await _obs_send_raw(request);
        break;
      case 'obs_general_version':
        result = await _obs_general_version(request);
        break;
      case 'obs_general_stats':
        result = await _obs_general_stats(request);
        break;
      case 'obs_general_hotkeys':
        result = await _obs_general_hotkeys(request);
        break;
      case 'obs_general_trigger_hotkey':
        result = await _obs_general_trigger_hotkey(request);
        break;
      case 'obs_general_sleep':
        result = await _obs_general_sleep(request);
        break;
      case 'obs_general_broadcast_custom_event':
        result = await _obs_general_broadcast_custom_event(request);
        break;
      default:
        // For all other tools, use the generic dispatch
        result = await _genericToolDispatch(toolName, request);
    }

    final textContent = result.content.whereType<TextContent>().firstOrNull;
    if (textContent != null) {
      final text = textContent.text;
      try {
        return jsonDecode(text);
      } catch (_) {
        return text;
      }
    }
    return result.content.map((c) => c.toString()).join('\n');
  }

  /// Generic dispatcher for tool calls that routes to the ObsMcpServer methods.
  FutureOr<CallToolResult> _genericToolDispatch(
    String toolName,
    CallToolRequest request,
  ) async {
    try {
      final server = obs_mcp_server.ObsMcpServer();
      dynamic result;
      switch (toolName) {
        case 'obs_scenes_list':
          result = await server.scenesList();
          break;
        case 'obs_scenes_group_list':
          result = await server.scenesGroupList();
          break;
        case 'obs_scenes_get_current_program':
          result = await server.scenesGetCurrentProgram();
          break;
        case 'obs_scenes_set_current_program':
          result = await server.scenesSetCurrentProgram(
            request.arguments!['sceneName'] as String,
          );
          break;
        case 'obs_scenes_get_current_preview':
          result = await server.scenesGetCurrentPreview();
          break;
        case 'obs_scenes_set_current_preview':
          result = await server.scenesSetCurrentPreview(
            request.arguments!['sceneName'] as String,
          );
          break;
        case 'obs_scenes_create':
          result = await server.scenesCreate(
            request.arguments!['sceneName'] as String,
          );
          break;
        case 'obs_scene_items_list':
          result = await server.sceneItemsList(
            request.arguments!['sceneName'] as String,
          );
          break;
        case 'obs_scene_items_group_list':
          result = await server.sceneItemsGroupList(
            request.arguments!['sceneName'] as String,
          );
          break;
        case 'obs_scene_items_get_id':
          result = await server.sceneItemsGetId(
            sceneName: request.arguments!['sceneName'] as String,
            sourceName: request.arguments!['sourceName'] as String,
          );
          break;
        case 'obs_scene_items_get_enabled':
          result = await server.sceneItemsGetEnabled(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
          );
          break;
        case 'obs_scene_items_set_enabled':
          result = await server.sceneItemsSetEnabled(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
            sceneItemEnabled: request.arguments!['sceneItemEnabled'] as bool,
          );
          break;
        case 'obs_scene_items_get_locked':
          result = await server.sceneItemsGetLocked(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
          );
          break;
        case 'obs_scene_items_set_locked':
          result = await server.sceneItemsSetLocked(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
            sceneItemLocked: request.arguments!['sceneItemLocked'] as bool,
          );
          break;
        case 'obs_scene_items_get_transform':
          result = await server.sceneItemsGetTransform(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
          );
          break;
        case 'obs_scene_items_set_transform':
          result = await server.sceneItemsSetTransform(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
            positionX: request.arguments?['positionX'] as num?,
            positionY: request.arguments?['positionY'] as num?,
            scaleX: request.arguments?['scaleX'] as num?,
            scaleY: request.arguments?['scaleY'] as num?,
            rotation: request.arguments?['rotation'] as num?,
            cropLeft: request.arguments?['cropLeft'] as int?,
            cropTop: request.arguments?['cropTop'] as int?,
            cropRight: request.arguments?['cropRight'] as int?,
            cropBottom: request.arguments?['cropBottom'] as int?,
            alignment: request.arguments?['alignment'] as int?,
            boundsType: request.arguments?['boundsType'] as String?,
            boundsAlignment: request.arguments?['boundsAlignment'] as int?,
            boundsWidth: request.arguments?['boundsWidth'] as num?,
            boundsHeight: request.arguments?['boundsHeight'] as num?,
          );
          break;
        case 'obs_inputs_list':
          result = await server.inputsList(
            inputKind: request.arguments?['inputKind'] as String?,
          );
          break;
        case 'obs_inputs_kind_list':
          result = await server.inputsKindList(
            unversioned: request.arguments?['unversioned'] as bool?,
          );
          break;
        case 'obs_inputs_special':
          result = await server.inputsSpecial();
          break;
        case 'obs_inputs_get_mute':
          result = await server.inputsGetMute(
            request.arguments!['inputName'] as String,
          );
          break;
        case 'obs_inputs_set_mute':
          result = await server.inputsSetMute(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            inputMuted: request.arguments!['inputMuted'] as bool,
          );
          break;
        case 'obs_inputs_toggle_mute':
          result = await server.inputsToggleMute(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_volume':
          result = await server.inputsGetVolume(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_settings':
          result = await server.inputsGetSettings(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_set_settings':
          result = await server.inputsSetSettings(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            inputSettings:
                request.arguments!['inputSettings'] as Map<String, dynamic>,
            overlay: request.arguments?['overlay'] as bool?,
          );
          break;
        case 'obs_inputs_create':
          result = await server.inputsCreate(
            sceneName: request.arguments?['sceneName'] as String?,
            inputName: request.arguments!['inputName'] as String,
            inputKind: request.arguments!['inputKind'] as String,
          );
          break;
        case 'obs_inputs_remove':
          result = await server.inputsRemove(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_stream_status':
          result = await server.streamStatus();
          break;
        case 'obs_stream_start':
          result = await server.streamStart();
          break;
        case 'obs_stream_stop':
          result = await server.streamStop();
          break;
        case 'obs_stream_toggle':
          result = await server.streamToggle();
          break;
        case 'obs_stream_send_caption':
          result = await server.streamSendCaption(
            request.arguments!['captionText'] as String,
          );
          break;
        case 'obs_record_status':
          result = await server.recordStatus();
          break;
        case 'obs_record_start':
          result = await server.recordStart();
          break;
        case 'obs_record_stop':
          result = await server.recordStop();
          break;
        case 'obs_record_toggle':
          result = await server.recordToggle();
          break;
        case 'obs_record_pause':
          result = await server.recordPause();
          break;
        case 'obs_record_resume':
          result = await server.recordResume();
          break;
        case 'obs_record_toggle_pause':
          result = await server.recordTogglePause();
          break;
        case 'obs_outputs_virtual_cam_status':
          result = await server.outputsVirtualCamStatus();
          break;
        case 'obs_outputs_virtual_cam_toggle':
          result = await server.outputsVirtualCamToggle();
          break;
        case 'obs_outputs_virtual_cam_start':
          result = await server.outputsVirtualCamStart();
          break;
        case 'obs_outputs_virtual_cam_stop':
          result = await server.outputsVirtualCamStop();
          break;
        case 'obs_outputs_replay_buffer_status':
          result = await server.outputsReplayBufferStatus();
          break;
        case 'obs_outputs_replay_buffer_toggle':
          result = await server.outputsReplayBufferToggle();
          break;
        case 'obs_outputs_replay_buffer_start':
          result = await server.outputsReplayBufferStart(
            outputName: request.arguments?['outputName'] as String?,
          );
          break;
        case 'obs_outputs_replay_buffer_stop':
          result = await server.outputsReplayBufferStop(
            outputName: request.arguments?['outputName'] as String?,
          );
          break;
        case 'obs_outputs_replay_buffer_save':
          result = await server.outputsReplayBufferSave(
            outputName: request.arguments?['outputName'] as String?,
          );
          break;
        case 'obs_outputs_toggle':
          result = await server.outputsToggle(
            request.arguments!['outputName'] as String,
          );
          break;
        case 'obs_outputs_start':
          result = await server.outputsStart(
            request.arguments!['outputName'] as String,
          );
          break;
        case 'obs_outputs_stop':
          result = await server.outputsStop(
            request.arguments!['outputName'] as String,
          );
          break;
        case 'obs_config_record_directory':
          result = await server.configRecordDirectory();
          break;
        case 'obs_config_stream_service_settings':
          result = await server.configStreamServiceSettings();
          break;
        case 'obs_ui_studio_mode_enabled':
          result = await server.uiStudioModeEnabled();
          break;
        case 'obs_ui_set_studio_mode':
          result = await server.uiSetStudioMode(
            request.arguments!['enabled'] as bool,
          );
          break;
        case 'obs_ui_open_input_properties':
          result = await server.uiOpenInputProperties(
            request.arguments!['inputName'] as String,
          );
          break;
        case 'obs_ui_open_input_filters':
          result = await server.uiOpenInputFilters(
            request.arguments!['inputName'] as String,
          );
          break;
        case 'obs_ui_open_input_interact':
          result = await server.uiOpenInputInteract(
            request.arguments!['inputName'] as String,
          );
          break;
        case 'obs_ui_monitor_list':
          result = await server.uiMonitorList();
          break;
        case 'obs_transitions_trigger_studio':
          result = await server.transitionsTriggerStudio();
          break;
        case 'obs_transitions_kind_list':
          result = await server.transitionsKindList();
          break;
        case 'obs_transitions_scene_list':
          result = await server.transitionsSceneList();
          break;
        case 'obs_transitions_get_current':
          result = await server.transitionsGetCurrent();
          break;
        case 'obs_transitions_set_current':
          result = await server.transitionsSetCurrent(
            request.arguments!['transitionName'] as String,
          );
          break;
        case 'obs_transitions_set_duration':
          result = await server.transitionsSetDuration(
            request.arguments!['duration'] as int,
          );
          break;
        case 'obs_transitions_get_cursor':
          result = await server.transitionsGetCursor();
          break;
        case 'obs_filters_kind_list':
          result = await server.filtersKindList();
          break;
        case 'obs_filters_list':
          result = await server.filtersList(
            request.arguments!['sourceName'] as String,
          );
          break;
        case 'obs_canvases_list':
          result = await server.canvasesList();
          break;
        case 'obs_connection_status':
          result = server.connectionStatus();
          break;
        case 'obs_connection_ping':
          result = await server.connectionPing();
          break;
        case 'obs_events_subscribe':
          result = await server.eventsSubscribe(
            mask: request.arguments?['mask'] as int?,
            subscriptions: (request.arguments?['subscriptions'] as List?)
                ?.cast<String>(),
          );
          break;
        case 'obs_wait_for_event':
          result = await server.waitForEvent(
            eventType: request.arguments!['eventType'] as String,
            timeoutMs: request.arguments?['timeoutMs'] as int?,
          );
          break;
        case 'obs_client_sleep':
          result = await server.clientSleep(
            ms: request.arguments!['ms'] as int,
          );
          break;
        case 'obs_scene_items_animate_transform':
          result = await server.sceneItemsAnimateTransform(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
            durationMs: request.arguments!['durationMs'] as int,
            targetPositionX: request.arguments?['targetPositionX'] as num?,
            targetPositionY: request.arguments?['targetPositionY'] as num?,
            targetScaleX: request.arguments?['targetScaleX'] as num?,
            targetScaleY: request.arguments?['targetScaleY'] as num?,
            targetRotation: request.arguments?['targetRotation'] as num?,
            frameRate: request.arguments?['frameRate'] as int?,
            easing: request.arguments?['easing'] as String?,
            restoreOnComplete: request.arguments?['restoreOnComplete'] as bool?,
          );
          break;
        // --- Filters ---
        case 'obs_filters_create':
          result = await server.filtersCreate(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
            filterKind: request.arguments!['filterKind'] as String,
            filterSettings:
                request.arguments?['filterSettings'] as Map<String, dynamic>?,
          );
          break;
        case 'obs_filters_default_settings':
          result = await server.filtersDefaultSettings(
            request.arguments!['filterKind'] as String,
          );
          break;
        case 'obs_filters_get':
          result = await server.filtersGet(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
          );
          break;
        case 'obs_filters_remove':
          result = await server.filtersRemove(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
          );
          break;
        case 'obs_filters_rename':
          result = await server.filtersRename(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
            newFilterName: request.arguments!['newFilterName'] as String,
          );
          break;
        case 'obs_filters_set_enabled':
          result = await server.filtersSetEnabled(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
            filterEnabled: request.arguments!['filterEnabled'] as bool,
          );
          break;
        case 'obs_filters_set_index':
          result = await server.filtersSetIndex(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
            filterIndex: request.arguments!['filterIndex'] as int,
          );
          break;
        case 'obs_filters_set_settings':
          result = await server.filtersSetSettings(
            sourceName: request.arguments!['sourceName'] as String,
            filterName: request.arguments!['filterName'] as String,
            filterSettings:
                request.arguments!['filterSettings'] as Map<String, dynamic>,
            overlay: request.arguments?['overlay'] as bool?,
          );
          break;
        // --- General (extended) ---
        case 'obs_general_call_vendor_request':
          result = await server.generalCallVendorRequest(
            vendorName: request.arguments!['vendorName'] as String,
            requestType: request.arguments!['requestType'] as String,
            requestData:
                request.arguments?['requestData'] as Map<String, dynamic>?,
          );
          break;
        case 'obs_general_trigger_hotkey_by_key':
          result = await server.generalTriggerHotkeyByKey(
            keyId: request.arguments!['keyId'] as String,
            keyModifiersShift: request.arguments?['shift'] as bool?,
            keyModifiersCtrl: request.arguments?['control'] as bool?,
            keyModifiersAlt: request.arguments?['alt'] as bool?,
            keyModifiersCmd: request.arguments?['command'] as bool?,
          );
          break;
        // --- Inputs (audio & extended) ---
        case 'obs_inputs_get_audio_balance':
          result = await server.inputsGetAudioBalance(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_audio_monitor_type':
          result = await server.inputsGetAudioMonitorType(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_audio_sync_offset':
          result = await server.inputsGetAudioSyncOffset(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_audio_tracks':
          result = await server.inputsGetAudioTracks(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_default_settings':
          result = await server.inputsGetDefaultSettings(
            inputKind: request.arguments!['inputKind'] as String,
          );
          break;
        case 'obs_inputs_get_deinterlace_field_order':
          result = await server.inputsGetDeinterlaceFieldOrder(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_deinterlace_mode':
          result = await server.inputsGetDeinterlaceMode(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_inputs_get_properties_list_items':
          result = await server.inputsGetPropertiesListItems(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            propertyName: request.arguments!['propertyName'] as String,
          );
          break;
        case 'obs_inputs_press_properties_button':
          result = await server.inputsPressPropertiesButton(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            propertyName: request.arguments!['propertyName'] as String,
          );
          break;
        case 'obs_inputs_set_audio_balance':
          result = await server.inputsSetAudioBalance(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            inputAudioBalance: (request.arguments!['inputAudioBalance'] as num)
                .toDouble(),
          );
          break;
        case 'obs_inputs_set_audio_monitor_type':
          result = await server.inputsSetAudioMonitorType(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            monitorType: request.arguments!['monitorType'] as int,
          );
          break;
        case 'obs_inputs_set_audio_sync_offset':
          result = await server.inputsSetAudioSyncOffset(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            inputAudioSyncOffset:
                request.arguments!['inputAudioSyncOffset'] as int,
          );
          break;
        case 'obs_inputs_set_audio_tracks':
          result = await server.inputsSetAudioTracks(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            inputAudioTracks: request.arguments!['inputAudioTracks'] as int,
          );
          break;
        case 'obs_inputs_set_deinterlace_field_order':
          result = await server.inputsSetDeinterlaceFieldOrder(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            deinterlaceFieldOrder: request.arguments!['fieldOrder'] as String,
          );
          break;
        case 'obs_inputs_set_deinterlace_mode':
          result = await server.inputsSetDeinterlaceMode(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            deinterlaceMode: request.arguments!['mode'] as String,
          );
          break;
        case 'obs_inputs_set_name':
          result = await server.inputsSetName(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            newInputName: request.arguments!['newInputName'] as String,
          );
          break;
        case 'obs_inputs_set_volume':
          result = await server.inputsSetVolume(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            inputVolume: (request.arguments!['inputVolume'] as num).toDouble(),
          );
          break;
        // --- Media Inputs ---
        case 'obs_media_inputs_get_status':
          result = await server.mediaInputsGetStatus(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
          );
          break;
        case 'obs_media_inputs_offset_cursor':
          result = await server.mediaInputsOffsetCursor(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            mediaCursorOffset: request.arguments!['mediaCursorOffset'] as int,
          );
          break;
        case 'obs_media_inputs_set_cursor':
          result = await server.mediaInputsSetCursor(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            mediaCursor: request.arguments!['mediaCursor'] as int,
          );
          break;
        case 'obs_media_inputs_trigger_action':
          result = await server.mediaInputsTriggerAction(
            inputName: request.arguments?['inputName'] as String?,
            inputUuid: request.arguments?['inputUuid'] as String?,
            mediaAction: request.arguments!['mediaAction'] as String,
          );
          break;
        // --- Outputs (extended) ---
        case 'obs_outputs_list':
          result = await server.outputsList();
          break;
        case 'obs_outputs_get_status':
          result = await server.outputsGetStatus(
            request.arguments!['outputName'] as String,
          );
          break;
        case 'obs_outputs_get_settings':
          result = await server.outputsGetSettings(
            request.arguments!['outputName'] as String,
          );
          break;
        case 'obs_outputs_set_settings':
          result = await server.outputsSetSettings(
            outputName: request.arguments!['outputName'] as String,
            outputSettings:
                request.arguments!['outputSettings'] as Map<String, dynamic>,
          );
          break;
        // --- Scene Items (extended) ---
        case 'obs_scene_items_create':
          result = await server.sceneItemsCreate(
            sceneName: request.arguments!['sceneName'] as String,
            sourceName: request.arguments!['sourceName'] as String,
            sceneItemEnabled: request.arguments?['sceneItemEnabled'] as bool?,
          );
          break;
        case 'obs_scene_items_duplicate':
          result = await server.sceneItemsDuplicate(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
            destinationSceneName:
                request.arguments?['destinationSceneName'] as String?,
          );
          break;
        case 'obs_scene_items_get_private_settings':
          result = await server.sceneItemsGetPrivateSettings(
            sceneName: request.arguments?['sceneName'] as String?,
            sceneItemId: request.arguments!['sceneItemId'] as int,
          );
          break;
        case 'obs_scene_items_get_source':
          result = await server.sceneItemsGetSource(
            sceneName: request.arguments?['sceneName'] as String?,
            sceneItemId: request.arguments!['sceneItemId'] as int,
          );
          break;
        case 'obs_scene_items_remove':
          result = await server.sceneItemsRemove(
            sceneName: request.arguments!['sceneName'] as String,
            sceneItemId: request.arguments!['sceneItemId'] as int,
          );
          break;
        case 'obs_scene_items_set_private_settings':
          result = await server.sceneItemsSetPrivateSettings(
            sceneName: request.arguments?['sceneName'] as String?,
            sceneItemId: request.arguments!['sceneItemId'] as int,
            sceneItemSettings:
                request.arguments!['sceneItemSettings'] as Map<String, dynamic>,
          );
          break;
        // --- Sources ---
        case 'obs_sources_get_active':
          result = await server.sourcesGetActive(
            request.arguments!['sourceName'] as String,
          );
          break;
        case 'obs_sources_get_private_settings':
          result = await server.sourcesGetPrivateSettings(
            sourceName: request.arguments?['sourceName'] as String?,
            sourceUuid: request.arguments?['sourceUuid'] as String?,
          );
          break;
        case 'obs_sources_get_screenshot':
          result = await server.sourcesGetScreenshot(
            sourceName: request.arguments!['sourceName'] as String,
            imageFormat: request.arguments!['imageFormat'] as String,
            imageWidth: request.arguments?['imageWidth'] as int?,
            imageHeight: request.arguments?['imageHeight'] as int?,
            compressionQuality:
                request.arguments?['imageCompressionQuality'] as int?,
          );
          break;
        case 'obs_sources_save_screenshot':
          result = await server.sourcesSaveScreenshot(
            sourceName: request.arguments!['sourceName'] as String,
            filePath: request.arguments!['filePath'] as String,
            imageFormat: request.arguments!['imageFormat'] as String,
            imageWidth: request.arguments?['imageWidth'] as int?,
            imageHeight: request.arguments?['imageHeight'] as int?,
            compressionQuality:
                request.arguments?['imageCompressionQuality'] as int?,
          );
          break;
        case 'obs_sources_set_private_settings':
          result = await server.sourcesSetPrivateSettings(
            sourceName: request.arguments?['sourceName'] as String?,
            sourceUuid: request.arguments?['sourceUuid'] as String?,
            sourceSettings:
                request.arguments!['sourceSettings'] as Map<String, dynamic>,
          );
          break;
        // --- Transitions (extended) ---
        case 'obs_transitions_set_settings':
          result = await server.transitionsSetSettings(
            transitionSettings:
                request.arguments!['transitionSettings']
                    as Map<String, dynamic>,
            overlay: request.arguments?['overlay'] as bool?,
          );
          break;
        case 'obs_transitions_set_t_bar':
          result = await server.transitionsSetTBar(
            position: (request.arguments!['position'] as num).toDouble(),
            release: request.arguments?['release'] as bool?,
          );
          break;
        default:
          throw StateError('Unknown tool: $toolName');
      }
      return CallToolResult(
        content: [TextContent(text: _serializeResult(result))],
      );
    } catch (e, st) {
      return _handleError(toolName, e, st);
    }
  }

  String _serializeResult(dynamic result) {
    if (result == null) return 'null';
    try {
      if (result is String) return result;
      if (result is bool || result is int || result is double)
        return jsonEncode(result);
      if (result is List) {
        final items = result
            .map((e) {
              if (e == null) return null;
              try {
                final j = e.toJson;
                if (j != null && j is Function) return j();
              } catch (_) {}
              return e;
            })
            .where((e) => e != null)
            .toList();
        return jsonEncode(items);
      }
      if (result is Map) return jsonEncode(result);
      try {
        final j = result.toJson;
        if (j != null && j is Function) return jsonEncode(j());
      } catch (_) {}
      return result.toString();
    } catch (_) {
      return result.toString();
    }
  }

  // ---------------------------------------------------------------------------
  // JS evaluation helpers
  // ---------------------------------------------------------------------------

  static void _evalJs(String code) {
    final fn = _createFunction(code);
    fn.callAsFunction(null);
  }

  static JSFunction _createFunction(String body) {
    // new Function(body) — creates an anonymous function from code
    return _newJsFunction(body);
  }
}
