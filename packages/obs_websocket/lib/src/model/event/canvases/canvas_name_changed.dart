import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_canvas_event.dart';

part 'canvas_name_changed.g.dart';

/// The name of a canvas has changed.
@JsonSerializable()
class CanvasNameChanged extends BaseCanvasEvent {
  /// Old name of the canvas
  final String oldCanvasName;

  CanvasNameChanged({
    required super.canvasName,
    required super.canvasUuid,
    required this.oldCanvasName,
  });

  factory CanvasNameChanged.fromJson(Map<String, dynamic> json) =>
      _$CanvasNameChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CanvasNameChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
