import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'current_scene_collection_changed.g.dart';

/// The current scene collection has changed.
///
/// Note: If polling has been paused during [CurrentSceneCollectionChanging], this is the que to restart polling.

@JsonSerializable()
class CurrentSceneCollectionChanged implements BaseEvent {
  /// Name of the new scene collection
  final String sceneCollectionName;

  CurrentSceneCollectionChanged({required this.sceneCollectionName});

  factory CurrentSceneCollectionChanged.fromJson(Map<String, dynamic> json) =>
      _$CurrentSceneCollectionChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrentSceneCollectionChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
