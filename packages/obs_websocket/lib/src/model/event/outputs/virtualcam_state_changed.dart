import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'virtualcam_state_changed.g.dart';

/// The state of the replay buffer output has changed.
@JsonSerializable()
class VirtualcamStateChanged implements BaseEvent {
  /// Whether the output is active
  final bool outputActive;

  /// The specific state of the output
  final String outputState;

  /// Creates an event for when the virtualcam state changes.
  VirtualcamStateChanged({
    required this.outputActive,
    required this.outputState,
  });

  /// Creates an event from a JSON map.
  factory VirtualcamStateChanged.fromJson(Map<String, dynamic> json) =>
      _$VirtualcamStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$VirtualcamStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
