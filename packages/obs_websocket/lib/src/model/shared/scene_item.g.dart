// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItem _$SceneItemFromJson(Map<String, dynamic> json) => SceneItem(
  sceneName: json['sceneName'] as String,
  sceneItemId: (json['sceneItemId'] as num).toInt(),
);

Map<String, dynamic> _$SceneItemToJson(SceneItem instance) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneItemId': instance.sceneItemId,
};
