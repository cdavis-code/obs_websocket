import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_volume_meters.g.dart';

/// A high-volume event providing volume levels of all active inputs every 50 milliseconds.
///
/// Complexity Rating: 4/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputVolumeMeters implements BaseEvent {
  /// Array of active inputs with their associated volume levels
  final List<Map<String, dynamic>> inputs;

  InputVolumeMeters({required this.inputs});

  factory InputVolumeMeters.fromJson(Map<String, dynamic> json) =>
      _$InputVolumeMetersFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputVolumeMetersToJson(this);

  @override
  String toString() => json.encode(toJson());
}
