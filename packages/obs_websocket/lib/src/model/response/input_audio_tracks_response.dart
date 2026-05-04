import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input_audio_tracks_response.g.dart';

/// Response for GetInputAudioTracks request
@JsonSerializable()
class InputAudioTracksResponse {
  /// Audio tracks of the input (bitmask where bit 0 = track 1, bit 1 = track 2, etc.)
  final int inputAudioTracks;

  InputAudioTracksResponse({required this.inputAudioTracks});

  factory InputAudioTracksResponse.fromJson(Map<String, dynamic> json) =>
      _$InputAudioTracksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputAudioTracksResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
