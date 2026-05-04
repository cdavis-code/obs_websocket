// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_audio_monitor_type_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputAudioMonitorTypeResponse _$InputAudioMonitorTypeResponseFromJson(
  Map<String, dynamic> json,
) => InputAudioMonitorTypeResponse(
  monitorType: $enumDecode(
    _$ObsMonitoringTypeEnumMap,
    json['monitorType'],
    unknownValue: ObsMonitoringType.none,
  ),
);

Map<String, dynamic> _$InputAudioMonitorTypeResponseToJson(
  InputAudioMonitorTypeResponse instance,
) => <String, dynamic>{
  'monitorType': _$ObsMonitoringTypeEnumMap[instance.monitorType]!,
};

const _$ObsMonitoringTypeEnumMap = {
  ObsMonitoringType.none: 'OBS_MONITORING_TYPE_NONE',
  ObsMonitoringType.monitorOnly: 'OBS_MONITORING_TYPE_MONITOR_ONLY',
  ObsMonitoringType.monitorAndOutput: 'OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT',
};
