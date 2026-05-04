import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_transition_ended.g.dart';

/// A scene transition has completed fully.
///
/// Note: Does not appear to trigger when the transition is interrupted by the
/// user.
@JsonSerializable()
class SceneTransitionEnded implements BaseEvent {
  /// Scene transition name
  final String transitionName;

  /// Scene transition UUID
  final String? transitionUuid;

  SceneTransitionEnded({required this.transitionName, this.transitionUuid});

  factory SceneTransitionEnded.fromJson(Map<String, dynamic> json) =>
      _$SceneTransitionEndedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneTransitionEndedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
