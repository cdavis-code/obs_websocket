import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'current_scene_transition_changed.g.dart';

/// The current scene transition has changed.
@JsonSerializable()
class CurrentSceneTransitionChanged implements BaseEvent {
  /// Name of the new transition
  final String transitionName;

  /// UUID of the new transition
  final String? transitionUuid;

  /// Creates an event for when the current scene transition changes.
  CurrentSceneTransitionChanged({
    required this.transitionName,
    this.transitionUuid,
  });

  /// Creates an event from a JSON map.
  factory CurrentSceneTransitionChanged.fromJson(Map<String, dynamic> json) =>
      _$CurrentSceneTransitionChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$CurrentSceneTransitionChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
