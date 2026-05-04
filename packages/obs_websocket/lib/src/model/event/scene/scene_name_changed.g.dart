// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_name_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneNameChanged _$SceneNameChangedFromJson(Map<String, dynamic> json) =>
    SceneNameChanged(
      sceneName: json['sceneName'] as String,
      oldSceneName: json['oldSceneName'] as String,
      sceneUuid: json['sceneUuid'] as String,
    );

Map<String, dynamic> _$SceneNameChangedToJson(SceneNameChanged instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'sceneUuid': instance.sceneUuid,
      'oldSceneName': instance.oldSceneName,
    };
