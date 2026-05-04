// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSettingsResponse _$VideoSettingsResponseFromJson(
  Map<String, dynamic> json,
) => VideoSettingsResponse(
  fpsNumerator: (json['fpsNumerator'] as num).toInt(),
  fpsDenominator: (json['fpsDenominator'] as num).toInt(),
  baseWidth: (json['baseWidth'] as num).toInt(),
  baseHeight: (json['baseHeight'] as num).toInt(),
  outputWidth: (json['outputWidth'] as num).toInt(),
  outputHeight: (json['outputHeight'] as num).toInt(),
);

Map<String, dynamic> _$VideoSettingsResponseToJson(
  VideoSettingsResponse instance,
) => <String, dynamic>{
  'fpsDenominator': instance.fpsDenominator,
  'baseWidth': instance.baseWidth,
  'baseHeight': instance.baseHeight,
  'outputWidth': instance.outputWidth,
  'outputHeight': instance.outputHeight,
  'fpsNumerator': instance.fpsNumerator,
};
