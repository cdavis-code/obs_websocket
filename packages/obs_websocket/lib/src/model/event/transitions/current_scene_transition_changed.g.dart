// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_scene_transition_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentSceneTransitionChanged _$CurrentSceneTransitionChangedFromJson(
  Map<String, dynamic> json,
) => CurrentSceneTransitionChanged(
  transitionName: json['transitionName'] as String,
  transitionUuid: json['transitionUuid'] as String?,
);

Map<String, dynamic> _$CurrentSceneTransitionChangedToJson(
  CurrentSceneTransitionChanged instance,
) => <String, dynamic>{
  'transitionName': instance.transitionName,
  'transitionUuid': instance.transitionUuid,
};
