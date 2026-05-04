import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'video_settings.g.dart';

@JsonSerializable()
class VideoSettings {
  final int? fpsNumerator;
  final int? fpsDenominator;
  final int? baseWidth;
  final int? baseHeight;
  final int? outputWidth;
  final int? outputHeight;

  VideoSettings({
    required this.fpsNumerator,
    required this.fpsDenominator,
    required this.baseWidth,
    required this.baseHeight,
    required this.outputWidth,
    required this.outputHeight,
  });

  factory VideoSettings.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$VideoSettingsToJson(this);

  @override
  String toString() => json.encode(toJson());
}
