import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../shared/canvas.dart';

part 'canvas_list_response.g.dart';

/// Response for GetCanvasList request.
///
/// Contains the current canvas name and a list of all canvases in OBS.
@JsonSerializable()
class CanvasListResponse {
  /// The name of the current active canvas
  final String currentCanvasName;

  /// List of all canvases available in OBS
  final List<Canvas> canvases;

  CanvasListResponse({required this.currentCanvasName, required this.canvases});

  factory CanvasListResponse.fromJson(Map<String, dynamic> json) =>
      _$CanvasListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
