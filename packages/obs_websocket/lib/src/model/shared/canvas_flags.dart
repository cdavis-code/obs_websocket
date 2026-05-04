import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'canvas_flags.g.dart';

/// These flags indicate the properties and capabilities of a canvas.
@JsonSerializable()
class CanvasFlags {
  /// Whether the canvas can be activated
  @JsonKey(name: 'ACTIVATE')
  final bool activate;

  /// Whether the canvas is ephemeral (temporary)
  @JsonKey(name: 'EPHEMERAL')
  final bool ephemeral;

  /// Whether this is the main canvas
  @JsonKey(name: 'MAIN')
  final bool main;

  /// Whether the canvas supports audio mixing
  @JsonKey(name: 'MIX_AUDIO')
  final bool mixAudio;

  /// Whether the canvas can be used as a scene reference
  @JsonKey(name: 'SCENE_REF')
  final bool sceneRef;

  CanvasFlags({
    required this.activate,
    required this.ephemeral,
    required this.main,
    required this.mixAudio,
    required this.sceneRef,
  });

  factory CanvasFlags.fromJson(Map<String, dynamic> json) =>
      _$CanvasFlagsFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasFlagsToJson(this);

  @override
  String toString() => json.encode(toJson());
}
