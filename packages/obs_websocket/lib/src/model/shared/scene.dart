import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'scene.g.dart';

@JsonSerializable()
class Scene {
  /// 	Name of the scene
  final String sceneName;

  final int sceneIndex;

  /// UUID of the scene
  final String? sceneUuid;

  Scene({required this.sceneName, required this.sceneIndex, this.sceneUuid});

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  Map<String, dynamic> toJson() => _$SceneToJson(this);

  @override
  String toString() => json.encode(toJson());
}
