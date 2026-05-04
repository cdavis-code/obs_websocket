import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'base_canvas_event.g.dart';

/// Base class for all canvas-related events.
///
/// This event is triggered when canvas operations occur, such as
/// creation, removal, or name changes. Introduced in OBS WebSocket v5.7.0.
@JsonSerializable()
class BaseCanvasEvent implements BaseEvent {
  /// Name of the canvas
  final String canvasName;

  /// UUID of the canvas
  final String canvasUuid;

  /// Creates a new canvas event with the specified name and UUID.
  BaseCanvasEvent({required this.canvasName, required this.canvasUuid});

  /// Creates a canvas event from a JSON map.
  factory BaseCanvasEvent.fromJson(Map<String, dynamic> json) =>
      _$BaseCanvasEventFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$BaseCanvasEventToJson(this);
}
