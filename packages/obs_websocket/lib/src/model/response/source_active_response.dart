import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'source_active_response.g.dart';

/// [videoActive] Whether the source is showing in Program
/// [videoShowing] Whether the source is showing in the UI (Preview, Projector, Properties)
@JsonSerializable()
class SourceActiveResponse {
  /// Whether the source is showing in Program
  final bool videoActive;

  /// Whether the source is showing in the UI (Preview, Projector, Properties)
  final bool videoShowing;

  SourceActiveResponse({required this.videoActive, required this.videoShowing});

  factory SourceActiveResponse.fromJson(Map<String, dynamic> json) =>
      _$SourceActiveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SourceActiveResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
