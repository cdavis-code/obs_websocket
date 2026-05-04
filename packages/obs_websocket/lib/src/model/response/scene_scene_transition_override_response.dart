import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'scene_scene_transition_override_response.g.dart';

@JsonSerializable()
class SceneSceneTransitionOverrideResponse {
  final String? transitionName;
  final int? transitionDuration;

  SceneSceneTransitionOverrideResponse({
    this.transitionName,
    this.transitionDuration,
  });

  factory SceneSceneTransitionOverrideResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SceneSceneTransitionOverrideResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SceneSceneTransitionOverrideResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
