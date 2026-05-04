import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_item_list_reindexed.g.dart';

/// A scene's item list has been reindexed.
@JsonSerializable()
class SceneItemListReindexed implements BaseEvent {
  /// Name of the scene
  final String sceneName;

  /// Array of scene item objects (with sceneItemId and sceneItemIndex)
  final List<Map<String, dynamic>> sceneItems;

  SceneItemListReindexed({required this.sceneName, required this.sceneItems});

  factory SceneItemListReindexed.fromJson(Map<String, dynamic> json) =>
      _$SceneItemListReindexedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemListReindexedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
