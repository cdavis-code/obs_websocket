import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'current_scene_collection_changing.g.dart';

/// The current scene collection has begun changing.
///
/// Note: We recommend using this event to trigger a pause of all polling requests, as performing any requests during a scene collection change is considered undefined behavior and can cause crashes!
@JsonSerializable()
class CurrentSceneCollectionChanging implements BaseEvent {
  /// Name of the current scene collection
  final String sceneCollectionName;

  CurrentSceneCollectionChanging({required this.sceneCollectionName});

  factory CurrentSceneCollectionChanging.fromJson(Map<String, dynamic> json) =>
      _$CurrentSceneCollectionChangingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrentSceneCollectionChangingToJson(this);

  @override
  String toString() => json.encode(toJson());
}
