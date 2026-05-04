// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scene _$SceneFromJson(Map<String, dynamic> json) => Scene(
  sceneName: json['sceneName'] as String,
  sceneIndex: (json['sceneIndex'] as num).toInt(),
  sceneUuid: json['sceneUuid'] as String?,
);

Map<String, dynamic> _$SceneToJson(Scene instance) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneIndex': instance.sceneIndex,
  'sceneUuid': instance.sceneUuid,
};
