// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_transform_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemTransformChanged _$SceneItemTransformChangedFromJson(
  Map<String, dynamic> json,
) => SceneItemTransformChanged(
  sceneName: json['sceneName'] as String,
  sceneItemId: (json['sceneItemId'] as num).toInt(),
  sceneItemTransform: json['sceneItemTransform'] as Map<String, dynamic>,
);

Map<String, dynamic> _$SceneItemTransformChangedToJson(
  SceneItemTransformChanged instance,
) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneItemId': instance.sceneItemId,
  'sceneItemTransform': instance.sceneItemTransform,
};
