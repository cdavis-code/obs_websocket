// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_list_reindexed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemListReindexed _$SceneItemListReindexedFromJson(
  Map<String, dynamic> json,
) => SceneItemListReindexed(
  sceneName: json['sceneName'] as String,
  sceneItems: (json['sceneItems'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$SceneItemListReindexedToJson(
  SceneItemListReindexed instance,
) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneItems': instance.sceneItems,
};
