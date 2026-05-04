import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_canvas_event.dart';

part 'canvas_created.g.dart';

/// A canvas has been created.
@JsonSerializable()
class CanvasCreated extends BaseCanvasEvent {
  CanvasCreated({required super.canvasName, required super.canvasUuid});

  factory CanvasCreated.fromJson(Map<String, dynamic> json) =>
      _$CanvasCreatedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CanvasCreatedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
