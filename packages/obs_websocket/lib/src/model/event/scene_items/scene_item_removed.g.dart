// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_removed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemRemoved _$SceneItemRemovedFromJson(Map<String, dynamic> json) =>
    SceneItemRemoved(
      sceneName: json['sceneName'] as String,
      sourceName: json['sourceName'] as String,
      sceneItemId: (json['sceneItemId'] as num).toInt(),
    );

Map<String, dynamic> _$SceneItemRemovedToJson(SceneItemRemoved instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'sourceName': instance.sourceName,
      'sceneItemId': instance.sceneItemId,
    };
