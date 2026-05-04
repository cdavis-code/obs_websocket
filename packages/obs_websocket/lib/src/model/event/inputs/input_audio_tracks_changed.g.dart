// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_audio_tracks_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputAudioTracksChanged _$InputAudioTracksChangedFromJson(
  Map<String, dynamic> json,
) => InputAudioTracksChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  inputAudioTracks: json['inputAudioTracks'] as Map<String, dynamic>,
);

Map<String, dynamic> _$InputAudioTracksChangedToJson(
  InputAudioTracksChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'inputAudioTracks': instance.inputAudioTracks,
};
