// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_selected.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemSelected _$SceneItemSelectedFromJson(Map<String, dynamic> json) =>
    SceneItemSelected(
      sceneName: json['sceneName'] as String,
      sceneItemId: (json['sceneItemId'] as num).toInt(),
    );

Map<String, dynamic> _$SceneItemSelectedToJson(SceneItemSelected instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'sceneItemId': instance.sceneItemId,
    };
