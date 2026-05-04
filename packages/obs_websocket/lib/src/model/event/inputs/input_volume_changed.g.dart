// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_volume_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputVolumeChanged _$InputVolumeChangedFromJson(Map<String, dynamic> json) =>
    InputVolumeChanged(
      inputName: json['inputName'] as String,
      inputUuid: json['inputUuid'] as String,
      inputVolumeMul: (json['inputVolumeMul'] as num).toDouble(),
      inputVolumeDb: (json['inputVolumeDb'] as num).toDouble(),
    );

Map<String, dynamic> _$InputVolumeChangedToJson(InputVolumeChanged instance) =>
    <String, dynamic>{
      'inputName': instance.inputName,
      'inputUuid': instance.inputUuid,
      'inputVolumeMul': instance.inputVolumeMul,
      'inputVolumeDb': instance.inputVolumeDb,
    };
