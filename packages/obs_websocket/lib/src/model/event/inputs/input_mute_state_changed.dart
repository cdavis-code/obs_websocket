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

  InputMuteStateChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputMuted,
  });

  factory InputMuteStateChanged.fromJson(Map<String, dynamic> json) =>
      _$InputMuteStateChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputMuteStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
