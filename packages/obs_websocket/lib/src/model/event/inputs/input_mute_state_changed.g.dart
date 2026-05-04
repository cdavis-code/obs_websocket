// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_mute_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputMuteStateChanged _$InputMuteStateChangedFromJson(
  Map<String, dynamic> json,
) => InputMuteStateChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  inputMuted: json['inputMuted'] as bool,
);

Map<String, dynamic> _$InputMuteStateChangedToJson(
  InputMuteStateChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'inputMuted': instance.inputMuted,
};
