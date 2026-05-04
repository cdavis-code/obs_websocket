// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamStateChanged _$StreamStateChangedFromJson(Map<String, dynamic> json) =>
    StreamStateChanged(
      outputActive: json['outputActive'] as bool,
      outputState: json['outputState'] as String,
    );

Map<String, dynamic> _$StreamStateChangedToJson(StreamStateChanged instance) =>
    <String, dynamic>{
      'outputActive': instance.outputActive,
      'outputState': instance.outputState,
    };
