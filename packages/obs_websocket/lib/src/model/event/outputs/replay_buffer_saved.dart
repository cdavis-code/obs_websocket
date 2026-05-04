import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'replay_buffer_saved.g.dart';

/// Path of the saved replay file
@JsonSerializable()
class ReplayBufferSaved implements BaseEvent {
  /// Path of the saved replay file
  final String savedReplayPath;

  ReplayBufferSaved({required this.savedReplayPath});

  factory ReplayBufferSaved.fromJson(Map<String, dynamic> json) =>
      _$ReplayBufferSavedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReplayBufferSavedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
