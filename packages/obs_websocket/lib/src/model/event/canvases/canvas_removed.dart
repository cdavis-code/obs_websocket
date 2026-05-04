import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_canvas_event.dart';

part 'canvas_removed.g.dart';

/// A canvas has been removed.
@JsonSerializable()
class CanvasRemoved extends BaseCanvasEvent {
  CanvasRemoved({required super.canvasName, required super.canvasUuid});

  factory CanvasRemoved.fromJson(Map<String, dynamic> json) =>
      _$CanvasRemovedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CanvasRemovedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
