// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_settings_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputSettingsChanged _$InputSettingsChangedFromJson(
  Map<String, dynamic> json,
) => InputSettingsChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  inputSettings: json['inputSettings'] as Map<String, dynamic>,
);

Map<String, dynamic> _$InputSettingsChangedToJson(
  InputSettingsChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'inputSettings': instance.inputSettings,
};
