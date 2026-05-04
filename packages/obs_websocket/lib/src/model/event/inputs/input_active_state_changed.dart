import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_active_state_changed.g.dart';

/// An input's active state has changed.
///
/// When an input is active, it means it's being shown by the program feed.
///
/// Complexity Rating: 3/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputActiveStateChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// Whether the input is active
  final bool videoActive;

  InputActiveStateChanged({
    required this.inputName,
    required this.inputUuid,
    required this.videoActive,
  });

  factory InputActiveStateChanged.fromJson(Map<String, dynamic> json) =>
      _$InputActiveStateChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputActiveStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
