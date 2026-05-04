import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_scene_event.dart';

part 'scene_name_changed.g.dart';

/// The name of a scene has changed.
@JsonSerializable()
class SceneNameChanged extends BaseSceneEvent {
  /// Old name of the scene
  final String oldSceneName;

  SceneNameChanged({
    required super.sceneName,
    required this.oldSceneName,
    required super.sceneUuid,
  });

  factory SceneNameChanged.fromJson(Map<String, dynamic> json) =>
      _$SceneNameChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneNameChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
