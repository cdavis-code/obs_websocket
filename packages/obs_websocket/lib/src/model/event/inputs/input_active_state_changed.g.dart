// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_active_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputActiveStateChanged _$InputActiveStateChangedFromJson(
  Map<String, dynamic> json,
) => InputActiveStateChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  videoActive: json['videoActive'] as bool,
);

Map<String, dynamic> _$InputActiveStateChangedToJson(
  InputActiveStateChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'videoActive': instance.videoActive,
};
