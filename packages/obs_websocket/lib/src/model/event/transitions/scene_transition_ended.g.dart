// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_transition_ended.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneTransitionEnded _$SceneTransitionEndedFromJson(
  Map<String, dynamic> json,
) => SceneTransitionEnded(
  transitionName: json['transitionName'] as String,
  transitionUuid: json['transitionUuid'] as String?,
);

Map<String, dynamic> _$SceneTransitionEndedToJson(
  SceneTransitionEnded instance,
) => <String, dynamic>{
  'transitionName': instance.transitionName,
  'transitionUuid': instance.transitionUuid,
};
