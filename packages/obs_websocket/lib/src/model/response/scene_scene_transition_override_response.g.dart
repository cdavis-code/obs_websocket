// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_scene_transition_override_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneSceneTransitionOverrideResponse
_$SceneSceneTransitionOverrideResponseFromJson(Map<String, dynamic> json) =>
    SceneSceneTransitionOverrideResponse(
      transitionName: json['transitionName'] as String?,
      transitionDuration: (json['transitionDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SceneSceneTransitionOverrideResponseToJson(
  SceneSceneTransitionOverrideResponse instance,
) => <String, dynamic>{
  'transitionName': instance.transitionName,
  'transitionDuration': instance.transitionDuration,
};
