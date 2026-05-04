import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'record_state_changed.g.dart';

/// The state of the record output has changed.
@JsonSerializable()
class RecordStateChanged implements BaseEvent {
  /// Whether the output is active
  final bool outputActive;

  /// The specific state of the output
  final String outputState;

  /// File name for the saved recording, if record stopped. null otherwise
  final String outputPath;

  /// Creates an event for when the record state changes.
  RecordStateChanged({
    required this.outputActive,
    required this.outputState,
    required this.outputPath,
  });

  /// Creates an event from a JSON map.
  factory RecordStateChanged.fromJson(Map<String, dynamic> json) =>
      _$RecordStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$RecordStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
