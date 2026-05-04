import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show Scene;

part 'scene_list_response.g.dart';

@JsonSerializable()
class SceneListResponse {
  final String currentProgramSceneName;
  final String? currentPreviewSceneName;
  final List<Scene> scenes;

  SceneListResponse({
    required this.currentProgramSceneName,
    this.currentPreviewSceneName,
    required this.scenes,
  });

  factory SceneListResponse.fromJson(Map<String, dynamic> json) =>
      _$SceneListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SceneListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
