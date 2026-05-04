// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_scene_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseSceneEvent _$BaseSceneEventFromJson(Map<String, dynamic> json) =>
    BaseSceneEvent(
      sceneName: json['sceneName'] as String,
      sceneUuid: json['sceneUuid'] as String,
    );

Map<String, dynamic> _$BaseSceneEventToJson(BaseSceneEvent instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'sceneUuid': instance.sceneUuid,
    };
