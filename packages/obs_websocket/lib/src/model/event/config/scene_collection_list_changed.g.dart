// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_collection_list_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneCollectionListChanged _$SceneCollectionListChangedFromJson(
  Map<String, dynamic> json,
) => SceneCollectionListChanged(
  sceneCollections: (json['sceneCollections'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SceneCollectionListChangedToJson(
  SceneCollectionListChanged instance,
) => <String, dynamic>{'sceneCollections': instance.sceneCollections};
