import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_item_lock_state_changed.g.dart';

/// A scene item's lock state has changed.
@JsonSerializable()
class SceneItemLockStateChanged implements BaseEvent {
  /// Name of the scene the item is in
  final String sceneName;

  /// Numeric ID of the scene item
  final int sceneItemId;

  /// Whether the scene item is locked
  final bool sceneItemLocked;

  /// Creates an event for when a scene item's lock state changes.
  SceneItemLockStateChanged({
    required this.sceneName,
    required this.sceneItemId,
    required this.sceneItemLocked,
  });

  /// Creates an event from a JSON map.
  factory SceneItemLockStateChanged.fromJson(Map<String, dynamic> json) =>
      _$SceneItemLockStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$SceneItemLockStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
