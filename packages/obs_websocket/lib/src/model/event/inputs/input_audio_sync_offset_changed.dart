import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_audio_sync_offset_changed.g.dart';

/// The sync offset of an input has changed.
///
/// Complexity Rating: 3/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputAudioSyncOffsetChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// New sync offset in milliseconds
  final int inputAudioSyncOffset;

  InputAudioSyncOffsetChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputAudioSyncOffset,
  });

  factory InputAudioSyncOffsetChanged.fromJson(Map<String, dynamic> json) =>
      _$InputAudioSyncOffsetChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputAudioSyncOffsetChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
