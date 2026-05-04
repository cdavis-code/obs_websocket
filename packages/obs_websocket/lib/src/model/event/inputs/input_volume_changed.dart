import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_volume_changed.g.dart';

/// An input's volume level has changed.
///
/// Complexity Rating: 3/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputVolumeChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// New volume level multiplier
  final double inputVolumeMul;

  /// The new volume level of the input in decibels
  final double inputVolumeDb;

  InputVolumeChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputVolumeMul,
    required this.inputVolumeDb,
  });

  factory InputVolumeChanged.fromJson(Map<String, dynamic> json) =>
      _$InputVolumeChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputVolumeChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
