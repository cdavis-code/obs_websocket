import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'current_scene_transition_duration_changed.g.dart';

/// The current scene transition duration has changed.
@JsonSerializable()
class CurrentSceneTransitionDurationChanged implements BaseEvent {
  /// Transition duration in milliseconds
  final int transitionDuration;

  CurrentSceneTransitionDurationChanged({required this.transitionDuration});

  factory CurrentSceneTransitionDurationChanged.fromJson(
    Map<String, dynamic> json,
  ) => _$CurrentSceneTransitionDurationChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CurrentSceneTransitionDurationChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
