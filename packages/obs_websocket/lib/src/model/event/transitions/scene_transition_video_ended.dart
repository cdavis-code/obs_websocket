import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'scene_transition_video_ended.g.dart';

/// A scene transition's video has completed fully.
///
/// Useful for stinger transitions to tell when the video actually ends.
/// `SceneTransitionEnded` only signifies the cut point, not the end of the
/// transition playback.
///
/// Note: Appears to be called by every transition, regardless of relevance.
@JsonSerializable()
class SceneTransitionVideoEnded implements BaseEvent {
  /// Scene transition name
  final String transitionName;

  /// Scene transition UUID
  final String? transitionUuid;

  SceneTransitionVideoEnded({
    required this.transitionName,
    this.transitionUuid,
  });

  factory SceneTransitionVideoEnded.fromJson(Map<String, dynamic> json) =>
      _$SceneTransitionVideoEndedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneTransitionVideoEndedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
