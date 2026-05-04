import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'input_audio_monitor_type_response.g.dart';

/// Response for GetInputAudioMonitorType request
@JsonSerializable()
class InputAudioMonitorTypeResponse {
  @JsonKey(unknownEnumValue: ObsMonitoringType.none)
  final ObsMonitoringType monitorType;

  InputAudioMonitorTypeResponse({required this.monitorType});

  factory InputAudioMonitorTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$InputAudioMonitorTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputAudioMonitorTypeResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
