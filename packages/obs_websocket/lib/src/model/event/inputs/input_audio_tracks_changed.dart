import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_audio_tracks_changed.g.dart';

/// The audio tracks of an input have changed.
///
/// Complexity Rating: 3/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputAudioTracksChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// Object of audio tracks along with their associated enable states
  final Map<String, dynamic> inputAudioTracks;

  InputAudioTracksChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputAudioTracks,
  });

  factory InputAudioTracksChanged.fromJson(Map<String, dynamic> json) =>
      _$InputAudioTracksChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputAudioTracksChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
