// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputCreated _$InputCreatedFromJson(Map<String, dynamic> json) => InputCreated(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  inputKind: json['inputKind'] as String,
  inputKindUnversioned: json['inputKindUnversioned'] as String,
  inputKindCaps: (json['inputKindCaps'] as num).toInt(),
  inputSettings: json['inputSettings'] as Map<String, dynamic>,
  defaultInputSettings: json['defaultInputSettings'] as Map<String, dynamic>,
);

Map<String, dynamic> _$InputCreatedToJson(InputCreated instance) =>
    <String, dynamic>{
      'inputName': instance.inputName,
      'inputUuid': instance.inputUuid,
      'inputKind': instance.inputKind,
      'inputKindUnversioned': instance.inputKindUnversioned,
      'inputKindCaps': instance.inputKindCaps,
      'inputSettings': instance.inputSettings,
      'defaultInputSettings': instance.defaultInputSettings,
    };
