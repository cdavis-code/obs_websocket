import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_scene_group_event.dart';

part 'scene_created.g.dart';

/// A new scene has been created.
@JsonSerializable()
class SceneCreated extends BaseSceneGroupEvent {
  SceneCreated({
    required super.sceneName,
    required super.sceneUuid,
    required super.isGroup,
  });

  factory SceneCreated.fromJson(Map<String, dynamic> json) =>
      _$SceneCreatedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneCreatedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
