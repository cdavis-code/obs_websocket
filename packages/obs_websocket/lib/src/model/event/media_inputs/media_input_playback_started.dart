import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'media_input_playback_started.g.dart';

/// A media input has started playing.
@JsonSerializable()
class MediaInputPlaybackStarted implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String? inputUuid;

  MediaInputPlaybackStarted({required this.inputName, this.inputUuid});

  factory MediaInputPlaybackStarted.fromJson(Map<String, dynamic> json) =>
      _$MediaInputPlaybackStartedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaInputPlaybackStartedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
