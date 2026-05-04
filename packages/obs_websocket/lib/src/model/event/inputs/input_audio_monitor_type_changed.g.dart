// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_audio_monitor_type_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputAudioMonitorTypeChanged _$InputAudioMonitorTypeChangedFromJson(
  Map<String, dynamic> json,
) => InputAudioMonitorTypeChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  monitorType: $enumDecode(_$ObsMonitoringTypeEnumMap, json['monitorType']),
);

Map<String, dynamic> _$InputAudioMonitorTypeChangedToJson(
  InputAudioMonitorTypeChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'monitorType': _$ObsMonitoringTypeEnumMap[instance.monitorType]!,
};

const _$ObsMonitoringTypeEnumMap = {
  ObsMonitoringType.none: 'none',
  ObsMonitoringType.play: 'play',
  ObsMonitoringType.pause: 'pause',
};
