import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_item_removed.g.dart';

/// This event is not emitted when the scene the item is in is removed.
@JsonSerializable()
class SceneItemRemoved implements BaseEvent {
  /// Name of the scene the item was removed from
  final String sceneName;

  /// Name of the underlying source (input/scene)
  final String sourceName;

  /// Numeric ID of the scene item
  final int sceneItemId;

  SceneItemRemoved({
    required this.sceneName,
    required this.sourceName,
    required this.sceneItemId,
  });

  factory SceneItemRemoved.fromJson(Map<String, dynamic> json) =>
      _$SceneItemRemovedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemRemovedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
