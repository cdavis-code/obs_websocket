// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_input_action_triggered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInputActionTriggered _$MediaInputActionTriggeredFromJson(
  Map<String, dynamic> json,
) => MediaInputActionTriggered(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String?,
  mediaAction: json['mediaAction'] as String,
);

Map<String, dynamic> _$MediaInputActionTriggeredToJson(
  MediaInputActionTriggered instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'mediaAction': instance.mediaAction,
};
