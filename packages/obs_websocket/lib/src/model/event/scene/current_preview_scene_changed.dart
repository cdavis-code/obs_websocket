import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base_scene_event.dart';

part 'current_preview_scene_changed.g.dart';

/// The current preview scene has changed.
@JsonSerializable()
class CurrentPreviewSceneChanged extends BaseSceneEvent {
  CurrentPreviewSceneChanged({
    required super.sceneName,
    required super.sceneUuid,
  });

  factory CurrentPreviewSceneChanged.fromJson(Map<String, dynamic> json) =>
      _$CurrentPreviewSceneChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrentPreviewSceneChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
