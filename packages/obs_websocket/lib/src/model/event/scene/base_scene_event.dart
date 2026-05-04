import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'base_scene_event.g.dart';

/// A base for scene events.
@JsonSerializable()
class BaseSceneEvent implements BaseEvent {
  /// Name of the new scene
  final String sceneName;

  /// UUID of the new scene
  final String sceneUuid;

  BaseSceneEvent({required this.sceneName, required this.sceneUuid});

  factory BaseSceneEvent.fromJson(Map<String, dynamic> json) =>
      _$BaseSceneEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseSceneEventToJson(this);
}
