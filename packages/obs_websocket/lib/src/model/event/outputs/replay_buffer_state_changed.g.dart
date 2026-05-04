// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replay_buffer_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplayBufferStateChanged _$ReplayBufferStateChangedFromJson(
  Map<String, dynamic> json,
) => ReplayBufferStateChanged(
  outputActive: json['outputActive'] as bool,
  outputState: json['outputState'] as String,
);

Map<String, dynamic> _$ReplayBufferStateChangedToJson(
  ReplayBufferStateChanged instance,
) => <String, dynamic>{
  'outputActive': instance.outputActive,
  'outputState': instance.outputState,
};
