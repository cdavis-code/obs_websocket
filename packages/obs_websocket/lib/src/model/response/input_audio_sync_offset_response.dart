import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input_audio_sync_offset_response.g.dart';

/// Response for GetInputAudioSyncOffset request
@JsonSerializable()
class InputAudioSyncOffsetResponse {
  /// Sync offset of the input (in milliseconds)
  final int inputAudioSyncOffset;

  InputAudioSyncOffsetResponse({required this.inputAudioSyncOffset});

  factory InputAudioSyncOffsetResponse.fromJson(Map<String, dynamic> json) =>
      _$InputAudioSyncOffsetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputAudioSyncOffsetResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
