// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordStateChanged _$RecordStateChangedFromJson(Map<String, dynamic> json) =>
    RecordStateChanged(
      outputActive: json['outputActive'] as bool,
      outputState: json['outputState'] as String,
      outputPath: json['outputPath'] as String,
    );

Map<String, dynamic> _$RecordStateChangedToJson(RecordStateChanged instance) =>
    <String, dynamic>{
      'outputActive': instance.outputActive,
      'outputState': instance.outputState,
      'outputPath': instance.outputPath,
    };
