import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_transition_started.g.dart';

/// A scene transition has started.
@JsonSerializable()
class SceneTransitionStarted implements BaseEvent {
  /// Scene transition name
  final String transitionName;

  /// Scene transition UUID
  final String? transitionUuid;

  SceneTransitionStarted({required this.transitionName, this.transitionUuid});

  factory SceneTransitionStarted.fromJson(Map<String, dynamic> json) =>
      _$SceneTransitionStartedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneTransitionStartedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
