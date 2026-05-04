// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputSettingsResponse _$InputSettingsResponseFromJson(
  Map<String, dynamic> json,
) => InputSettingsResponse(
  inputSettings: json['inputSettings'] as Map<String, dynamic>,
  inputKind: json['inputKind'] as String,
);

Map<String, dynamic> _$InputSettingsResponseToJson(
  InputSettingsResponse instance,
) => <String, dynamic>{
  'inputSettings': instance.inputSettings,
  'inputKind': instance.inputKind,
};
