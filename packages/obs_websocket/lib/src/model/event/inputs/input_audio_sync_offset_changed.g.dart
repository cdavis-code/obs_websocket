// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_audio_sync_offset_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputAudioSyncOffsetChanged _$InputAudioSyncOffsetChangedFromJson(
  Map<String, dynamic> json,
) => InputAudioSyncOffsetChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  inputAudioSyncOffset: (json['inputAudioSyncOffset'] as num).toInt(),
);

Map<String, dynamic> _$InputAudioSyncOffsetChangedToJson(
  InputAudioSyncOffsetChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'inputAudioSyncOffset': instance.inputAudioSyncOffset,
};
