import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_scene_group_event.dart';

part 'scene_removed.g.dart';

/// A scene has been removed.
@JsonSerializable()
class SceneRemoved extends BaseSceneGroupEvent {
  SceneRemoved({
    required super.sceneName,
    required super.sceneUuid,
    required super.isGroup,
  });

  factory SceneRemoved.fromJson(Map<String, dynamic> json) =>
      _$SceneRemovedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneRemovedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
