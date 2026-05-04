// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_enabled.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemEnabled _$SceneItemEnabledFromJson(Map<String, dynamic> json) =>
    SceneItemEnabled(
      sceneName: json['sceneName'] as String,
      sceneItemId: (json['sceneItemId'] as num).toInt(),
    );

Map<String, dynamic> _$SceneItemEnabledToJson(SceneItemEnabled instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'sceneItemId': instance.sceneItemId,
    };
