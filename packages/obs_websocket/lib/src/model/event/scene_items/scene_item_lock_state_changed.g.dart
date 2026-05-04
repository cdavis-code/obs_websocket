// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_lock_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemLockStateChanged _$SceneItemLockStateChangedFromJson(
  Map<String, dynamic> json,
) => SceneItemLockStateChanged(
  sceneName: json['sceneName'] as String,
  sceneItemId: (json['sceneItemId'] as num).toInt(),
  sceneItemLocked: json['sceneItemLocked'] as bool,
);

Map<String, dynamic> _$SceneItemLockStateChangedToJson(
  SceneItemLockStateChanged instance,
) => <String, dynamic>{
  'sceneName': instance.sceneName,
  'sceneItemId': instance.sceneItemId,
  'sceneItemLocked': instance.sceneItemLocked,
};
