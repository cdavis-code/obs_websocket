import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'base_scene_event.g.dart';

/// Base class for all scene-related events.
///
/// This event is triggered when scene operations occur, such as
/// creation, removal, name changes, or scene switching.
@JsonSerializable()
class BaseSceneEvent implements BaseEvent {
  /// Name of the new scene
  final String sceneName;

  /// UUID of the new scene
  final String sceneUuid;

  /// Creates a new scene event with the specified name and UUID.
  BaseSceneEvent({required this.sceneName, required this.sceneUuid});

  /// Creates a scene event from a JSON map.
  factory BaseSceneEvent.fromJson(Map<String, dynamic> json) =>
      _$BaseSceneEventFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$BaseSceneEventToJson(this);
}
