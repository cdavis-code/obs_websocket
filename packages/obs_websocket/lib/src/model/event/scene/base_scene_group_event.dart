import 'package:json_annotation/json_annotation.dart';

import 'base_scene_event.dart';

part 'base_scene_group_event.g.dart';

/// A base for scene group events.
@JsonSerializable()
class BaseSceneGroupEvent extends BaseSceneEvent {
  /// Whether the new scene is a group
  final bool isGroup;

  BaseSceneGroupEvent({
    required super.sceneName,
    required super.sceneUuid,
    required this.isGroup,
  });

  factory BaseSceneGroupEvent.fromJson(Map<String, dynamic> json) =>
      _$BaseSceneGroupEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseSceneGroupEventToJson(this);
}
