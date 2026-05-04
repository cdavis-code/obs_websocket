import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show Scene;

part 'scene_item.g.dart';

@JsonSerializable()
class SceneItem extends Scene {
  /// Numeric ID of the scene item
  final int sceneItemId;

  SceneItem({required super.sceneName, required this.sceneItemId})
    : super(sceneIndex: sceneItemId);

  factory SceneItem.fromJson(Map<String, dynamic> json) =>
      _$SceneItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemToJson(this);

  @override
  String toString() => json.encode(toJson());
}
