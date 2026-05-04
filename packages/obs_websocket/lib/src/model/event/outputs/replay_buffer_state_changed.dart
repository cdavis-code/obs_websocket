import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'replay_buffer_state_changed.g.dart';

/// The state of the replay buffer output has changed.
@JsonSerializable()
class ReplayBufferStateChanged implements BaseEvent {
  /// Whether the output is active
  final bool outputActive;

  /// The specific state of the output
  final String outputState;

  /// Creates an event for when the replay buffer state changes.
  ReplayBufferStateChanged({
    required this.outputActive,
    required this.outputState,
  });

  /// Creates an event from a JSON map.
  factory ReplayBufferStateChanged.fromJson(Map<String, dynamic> json) =>
      _$ReplayBufferStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$ReplayBufferStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
