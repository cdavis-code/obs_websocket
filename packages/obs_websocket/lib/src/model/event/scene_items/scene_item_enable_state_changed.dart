import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_item_enable_state_changed.g.dart';

/// A scene item's enable state has changed.
@JsonSerializable()
class SceneItemEnableStateChanged implements BaseEvent {
  /// Name of the scene the item is in
  final String sceneName;

  /// Numeric ID of the scene item
  final int sceneItemId;

  /// Whether the scene item is enabled (visible)
  final bool sceneItemEnabled;

  SceneItemEnableStateChanged({
    required this.sceneName,
    required this.sceneItemId,
    required this.sceneItemEnabled,
  });

  factory SceneItemEnableStateChanged.fromJson(Map<String, dynamic> json) =>
      _$SceneItemEnableStateChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemEnableStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
