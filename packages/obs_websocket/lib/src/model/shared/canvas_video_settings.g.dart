// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_video_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasVideoSettings _$CanvasVideoSettingsFromJson(Map<String, dynamic> json) =>
    CanvasVideoSettings(
      baseHeight: (json['baseHeight'] as num).toInt(),
      baseWidth: (json['baseWidth'] as num).toInt(),
      fpsDenominator: (json['fpsDenominator'] as num).toInt(),
      fpsNumerator: (json['fpsNumerator'] as num).toInt(),
      outputHeight: (json['outputHeight'] as num).toInt(),
      outputWidth: (json['outputWidth'] as num).toInt(),
    );

Map<String, dynamic> _$CanvasVideoSettingsToJson(
  CanvasVideoSettings instance,
) => <String, dynamic>{
  'baseHeight': instance.baseHeight,
  'baseWidth': instance.baseWidth,
  'fpsDenominator': instance.fpsDenominator,
  'fpsNumerator': instance.fpsNumerator,
  'outputHeight': instance.outputHeight,
  'outputWidth': instance.outputWidth,
};
