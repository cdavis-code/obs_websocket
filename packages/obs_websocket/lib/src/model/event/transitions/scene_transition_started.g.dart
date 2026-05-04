// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_transition_started.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneTransitionStarted _$SceneTransitionStartedFromJson(
  Map<String, dynamic> json,
) => SceneTransitionStarted(
  transitionName: json['transitionName'] as String,
  transitionUuid: json['transitionUuid'] as String?,
);

Map<String, dynamic> _$SceneTransitionStartedToJson(
  SceneTransitionStarted instance,
) => <String, dynamic>{
  'transitionName': instance.transitionName,
  'transitionUuid': instance.transitionUuid,
};
