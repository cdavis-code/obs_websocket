// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_list_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneListChanged _$SceneListChangedFromJson(Map<String, dynamic> json) =>
    SceneListChanged(
      scenes: (json['scenes'] as List<dynamic>)
          .map((e) => Scene.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SceneListChangedToJson(SceneListChanged instance) =>
    <String, dynamic>{'scenes': instance.scenes};
