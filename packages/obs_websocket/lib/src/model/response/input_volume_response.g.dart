// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_volume_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputVolumeResponse _$InputVolumeResponseFromJson(Map<String, dynamic> json) =>
    InputVolumeResponse(
      inputVolumeMul: (json['inputVolumeMul'] as num).toDouble(),
      inputVolumeDb: (json['inputVolumeDb'] as num).toDouble(),
    );

Map<String, dynamic> _$InputVolumeResponseToJson(
  InputVolumeResponse instance,
) => <String, dynamic>{
  'inputVolumeMul': instance.inputVolumeMul,
  'inputVolumeDb': instance.inputVolumeDb,
};
