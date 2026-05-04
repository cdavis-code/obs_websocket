// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_enable_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemEnableStateChanged _$SceneItemEnableStateChangedFromJson(
  Map<String, dynamic> json,
) => SceneItemEnableStateChanged(
  sceneName: json['sceneName'] as String,
  sceneItemId: (json['sceneItemId'] as num).toInt(),
  sceneItemEnabled: json['sceneItemEnabled'] as bool,
);

Map<String, dynamic> _$SceneItemEnableStateChangedToJson(
  SceneItemEnableStateChanged instance,
) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneItemId': instance.sceneItemId,
  'sceneItemEnabled': instance.sceneItemEnabled,
};
