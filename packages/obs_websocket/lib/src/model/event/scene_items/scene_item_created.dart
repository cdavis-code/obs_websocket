import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_item_created.g.dart';

/// A scene item's enable state has changed.
@JsonSerializable()
class SceneItemCreated implements BaseEvent {
  /// 	Name of the scene the item was added to
  final String sceneName;

  /// Name of the underlying source (input/scene)
  final String sourceName;

  /// Numeric ID of the scene item
  final int sceneItemId;

  /// Index position of the item
  final int sceneItemIndex;

  SceneItemCreated({
    required this.sceneName,
    required this.sourceName,
    required this.sceneItemId,
    required this.sceneItemIndex,
  });

  factory SceneItemCreated.fromJson(Map<String, dynamic> json) =>
      _$SceneItemCreatedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemCreatedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
