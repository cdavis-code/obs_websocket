import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'canvas_video_settings.g.dart';

/// Contains resolution and frame rate configuration.
@JsonSerializable()
class CanvasVideoSettings {
  /// The base height of the canvas in pixels
  final int baseHeight;

  /// The base width of the canvas in pixels
  final int baseWidth;

  /// The frame rate denominator
  final int fpsDenominator;

  /// The frame rate numerator
  final int fpsNumerator;

  /// The output height in pixels
  final int outputHeight;

  /// The output width in pixels
  final int outputWidth;

  CanvasVideoSettings({
    required this.baseHeight,
    required this.baseWidth,
    required this.fpsDenominator,
    required this.fpsNumerator,
    required this.outputHeight,
    required this.outputWidth,
  });

  factory CanvasVideoSettings.fromJson(Map<String, dynamic> json) =>
      _$CanvasVideoSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasVideoSettingsToJson(this);

  @override
  String toString() => json.encode(toJson());
}
