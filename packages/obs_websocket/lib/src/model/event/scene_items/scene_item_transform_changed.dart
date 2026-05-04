import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_item_transform_changed.g.dart';

/// The transform/crop of a scene item has changed.
@JsonSerializable()
class SceneItemTransformChanged implements BaseEvent {
  /// The name of the scene the item is in
  final String sceneName;

  /// Numeric ID of the scene item
  final int sceneItemId;

  /// New transform/crop info of the scene item
  final Map<String, dynamic> sceneItemTransform;

  SceneItemTransformChanged({
    required this.sceneName,
    required this.sceneItemId,
    required this.sceneItemTransform,
  });

  factory SceneItemTransformChanged.fromJson(Map<String, dynamic> json) =>
      _$SceneItemTransformChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemTransformChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
