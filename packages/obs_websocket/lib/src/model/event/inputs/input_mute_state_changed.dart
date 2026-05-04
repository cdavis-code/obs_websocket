import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_mute_state_changed.g.dart';

/// An input's mute state has changed.
///
/// Complexity Rating: 2/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputMuteStateChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// Whether the input is muted
  final bool inputMuted;

  /// Creates an event for when an input's mute state changes.
  InputMuteStateChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputMuted,
  });

  /// Creates an event from a JSON map.
  factory InputMuteStateChanged.fromJson(Map<String, dynamic> json) =>
      _$InputMuteStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$InputMuteStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
