// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemListResponse _$SceneItemListResponseFromJson(
  Map<String, dynamic> json,
) => SceneItemListResponse(
  sceneItems: (json['sceneItems'] as List<dynamic>)
      .map((e) => SceneItemDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SceneItemListResponseToJson(
  SceneItemListResponse instance,
) => <String, dynamic>{'sceneItems': instance.sceneItems};
