import 'package:json_annotation/json_annotation.dart';

import 'base_scene_event.dart';

part 'base_scene_group_event.g.dart';

/// Base class for scene group events.
///
/// Extends [BaseSceneEvent] to include information about whether
/// the scene is a group (a collection of sources grouped together).
@JsonSerializable()
class BaseSceneGroupEvent extends BaseSceneEvent {
  /// Whether the new scene is a group
  final bool isGroup;

  /// Creates a new scene group event.
  BaseSceneGroupEvent({
    required super.sceneName,
    required super.sceneUuid,
    required this.isGroup,
  });

  /// Creates a scene group event from a JSON map.
  factory BaseSceneGroupEvent.fromJson(Map<String, dynamic> json) =>
      _$BaseSceneGroupEventFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$BaseSceneGroupEventToJson(this);
}
