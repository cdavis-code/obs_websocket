import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_scene_event.dart';

part 'current_program_scene_changed.g.dart';

/// The current program scene has changed.
@JsonSerializable()
class CurrentProgramSceneChanged extends BaseSceneEvent {
  CurrentProgramSceneChanged({
    required super.sceneName,
    required super.sceneUuid,
  });

  factory CurrentProgramSceneChanged.fromJson(Map<String, dynamic> json) =>
      _$CurrentProgramSceneChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrentProgramSceneChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
