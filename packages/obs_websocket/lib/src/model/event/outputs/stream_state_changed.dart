import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'stream_state_changed.g.dart';

/// The state of the stream output has changed.
@JsonSerializable()
class StreamStateChanged implements BaseEvent {
  /// Whether the output is active
  final bool outputActive;

  /// The specific state of the output
  final String outputState;

  StreamStateChanged({required this.outputActive, required this.outputState});

  factory StreamStateChanged.fromJson(Map<String, dynamic> json) =>
      _$StreamStateChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StreamStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
