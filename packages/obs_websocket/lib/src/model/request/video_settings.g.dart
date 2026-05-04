// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSettings _$VideoSettingsFromJson(Map<String, dynamic> json) =>
    VideoSettings(
      fpsNumerator: (json['fpsNumerator'] as num?)?.toInt(),
      fpsDenominator: (json['fpsDenominator'] as num?)?.toInt(),
      baseWidth: (json['baseWidth'] as num?)?.toInt(),
      baseHeight: (json['baseHeight'] as num?)?.toInt(),
      outputWidth: (json['outputWidth'] as num?)?.toInt(),
      outputHeight: (json['outputHeight'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VideoSettingsToJson(VideoSettings instance) =>
    <String, dynamic>{
      'fpsNumerator': instance.fpsNumerator,
      'fpsDenominator': instance.fpsDenominator,
      'baseWidth': instance.baseWidth,
      'baseHeight': instance.baseHeight,
      'outputWidth': instance.outputWidth,
      'outputHeight': instance.outputHeight,
    };
