import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'media_input_playback_ended.g.dart';

/// A media input has finished playing.
@JsonSerializable()
class MediaInputPlaybackEnded implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String? inputUuid;

  MediaInputPlaybackEnded({required this.inputName, this.inputUuid});

  factory MediaInputPlaybackEnded.fromJson(Map<String, dynamic> json) =>
      _$MediaInputPlaybackEndedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaInputPlaybackEndedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
