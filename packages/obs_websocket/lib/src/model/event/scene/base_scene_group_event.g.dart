// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_scene_group_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseSceneGroupEvent _$BaseSceneGroupEventFromJson(Map<String, dynamic> json) =>
    BaseSceneGroupEvent(
      sceneName: json['sceneName'] as String,
      sceneUuid: json['sceneUuid'] as String,
      isGroup: json['isGroup'] as bool,
    );

Map<String, dynamic> _$BaseSceneGroupEventToJson(
  BaseSceneGroupEvent instance,
) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneUuid': instance.sceneUuid,
  'isGroup': instance.isGroup,
};
