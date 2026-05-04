// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_collection_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneCollectionListResponse _$SceneCollectionListResponseFromJson(
  Map<String, dynamic> json,
) => SceneCollectionListResponse(
  currentSceneCollectionName: json['currentSceneCollectionName'] as String,
  sceneCollections: (json['sceneCollections'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SceneCollectionListResponseToJson(
  SceneCollectionListResponse instance,
) => <String, dynamic>{
  'currentSceneCollectionName': instance.currentSceneCollectionName,
  'sceneCollections': instance.sceneCollections,
};
