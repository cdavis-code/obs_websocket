import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show Scene;

part 'scene_item_enabled.g.dart';

@JsonSerializable()
class SceneItemEnabled extends Scene {
  final int sceneItemId;

  SceneItemEnabled({required super.sceneName, required this.sceneItemId})
    : super(sceneIndex: sceneItemId);

  factory SceneItemEnabled.fromJson(Map<String, dynamic> json) =>
      _$SceneItemEnabledFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemEnabledToJson(this);

  @override
  String toString() => json.encode(toJson());
}
