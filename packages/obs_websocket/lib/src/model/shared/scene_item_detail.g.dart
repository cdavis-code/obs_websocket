// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_item_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneItemDetail _$SceneItemDetailFromJson(Map<String, dynamic> json) =>
    SceneItemDetail(
      inputKind: json['inputKind'] as String?,
      isGroup: json['isGroup'] as bool?,
      sceneItemBlendMode: json['sceneItemBlendMode'] as String,
      sceneItemEnabled: json['sceneItemEnabled'] as bool,
      sceneItemId: (json['sceneItemId'] as num).toInt(),
      sceneItemIndex: (json['sceneItemIndex'] as num).toInt(),
      sceneItemLocked: json['sceneItemLocked'] as bool,
      sceneItemTransform: Transform.fromJson(
        json['sceneItemTransform'] as Map<String, dynamic>,
      ),
      sourceName: json['sourceName'] as String,
      sourceType: json['sourceType'] as String,
    );

Map<String, dynamic> _$SceneItemDetailToJson(SceneItemDetail instance) =>
    <String, dynamic>{
      'inputKind': instance.inputKind,
      'isGroup': instance.isGroup,
      'sceneItemBlendMode': instance.sceneItemBlendMode,
      'sceneItemEnabled': instance.sceneItemEnabled,
      'sceneItemId': instance.sceneItemId,
      'sceneItemIndex': instance.sceneItemIndex,
      'sceneItemLocked': instance.sceneItemLocked,
      'sceneItemTransform': instance.sceneItemTransform,
      'sourceName': instance.sourceName,
      'sourceType': instance.sourceType,
    };
