import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_collection_list_changed.g.dart';

/// The scene collection list has changed.
@JsonSerializable()
class SceneCollectionListChanged implements BaseEvent {
  /// 	Updated list of scene collections
  final List<String> sceneCollections;

  SceneCollectionListChanged({required this.sceneCollections});

  factory SceneCollectionListChanged.fromJson(Map<String, dynamic> json) =>
      _$SceneCollectionListChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneCollectionListChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
