// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneCreated _$SceneCreatedFromJson(Map<String, dynamic> json) => SceneCreated(
  sceneName: json['sceneName'] as String,
  sceneUuid: json['sceneUuid'] as String,
  isGroup: json['isGroup'] as bool,
);

Map<String, dynamic> _$SceneCreatedToJson(SceneCreated instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'sceneUuid': instance.sceneUuid,
      'isGroup': instance.isGroup,
    };
