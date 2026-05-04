import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/src/model/request/video_settings.dart'
    show VideoSettings;

part 'video_settings_response.g.dart';

@JsonSerializable()
class VideoSettingsResponse extends VideoSettings {
  @override
  int get fpsNumerator => super.fpsNumerator!;

  VideoSettingsResponse({
    required int fpsNumerator,
    required int fpsDenominator,
    required int baseWidth,
    required int baseHeight,
    required int outputWidth,
    required int outputHeight,
  }) : super(
         fpsNumerator: fpsNumerator,
         fpsDenominator: fpsDenominator,
         baseWidth: baseWidth,
         baseHeight: baseHeight,
         outputWidth: outputWidth,
         outputHeight: outputHeight,
       );

  factory VideoSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VideoSettingsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
