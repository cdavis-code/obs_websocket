import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/src/model/shared/scene.dart';

part 'scene_list_changed.g.dart';

/// The list of scenes has changed.
@JsonSerializable()
class SceneListChanged {
  /// Updated array of scenes
  final List<Scene> scenes;

  SceneListChanged({required this.scenes});

  factory SceneListChanged.fromJson(Map<String, dynamic> json) =>
      _$SceneListChangedFromJson(json);

  Map<String, dynamic> toJson() => _$SceneListChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
