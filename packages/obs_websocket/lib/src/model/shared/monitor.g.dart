// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Monitor _$MonitorFromJson(Map<String, dynamic> json) => Monitor(
  monitorHeight: (json['monitorHeight'] as num).toInt(),
  monitorIndex: (json['monitorIndex'] as num).toInt(),
  monitorName: json['monitorName'] as String,
  monitorPositionX: (json['monitorPositionX'] as num).toInt(),
  monitorPositionY: (json['monitorPositionY'] as num).toInt(),
  monitorWidth: (json['monitorWidth'] as num).toInt(),
);

Map<String, dynamic> _$MonitorToJson(Monitor instance) => <String, dynamic>{
  'monitorHeight': instance.monitorHeight,
  'monitorIndex': instance.monitorIndex,
  'monitorName': instance.monitorName,
  'monitorPositionX': instance.monitorPositionX,
  'monitorPositionY': instance.monitorPositionY,
  'monitorWidth': instance.monitorWidth,
};
