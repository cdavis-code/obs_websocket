import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'canvas_flags.dart';
import 'canvas_video_settings.dart';

part 'canvas.g.dart';

/// Represents a canvas in OBS.
///
/// Canvas is a workspace area where sources are placed and arranged.
/// Multiple canvases can exist in OBS, each with its own settings and UUID.
@JsonSerializable()
class Canvas {
  /// Flags indicating the properties and capabilities of the canvas
  final CanvasFlags canvasFlags;

  /// The name of the canvas
  final String canvasName;

  /// The unique identifier for the canvas (UUID format)
  final String canvasUuid;

  /// Video settings for the canvas including resolution and frame rate
  final CanvasVideoSettings canvasVideoSettings;

  Canvas({
    required this.canvasFlags,
    required this.canvasName,
    required this.canvasUuid,
    required this.canvasVideoSettings,
  });

  factory Canvas.fromJson(Map<String, dynamic> json) => _$CanvasFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasToJson(this);

  @override
  String toString() => json.encode(toJson());
}
