import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../base_event.dart';

part 'input_audio_monitor_type_changed.g.dart';

/// The monitor type of an input has changed.
///
/// Available types are:
///
/// OBS_MONITORING_TYPE_NONE
///
/// OBS_MONITORING_TYPE_MONITOR_ONLY
///
/// OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT
///
/// Complexity Rating: 2/5
///
/// Latest Supported RPC Version: 1
///
/// Added in v5.0.0

@JsonSerializable()
class InputAudioMonitorTypeChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// New monitor type of the input
  final ObsMonitoringType monitorType;

  InputAudioMonitorTypeChanged({
    required this.inputName,
    required this.inputUuid,
    required this.monitorType,
  });

  factory InputAudioMonitorTypeChanged.fromJson(Map<String, dynamic> json) =>
      _$InputAudioMonitorTypeChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputAudioMonitorTypeChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
