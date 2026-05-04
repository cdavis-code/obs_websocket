// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamStatusResponse _$StreamStatusResponseFromJson(
  Map<String, dynamic> json,
) => StreamStatusResponse(
  outputActive: json['outputActive'] as bool,
  outputReconnecting: json['outputReconnecting'] as bool,
  outputTimecode: json['outputTimecode'] as String,
  outputDuration: (json['outputDuration'] as num).toInt(),
  outputCongestion: (json['outputCongestion'] as num).toDouble(),
  outputBytes: (json['outputBytes'] as num).toInt(),
  outputSkippedFrames: (json['outputSkippedFrames'] as num).toInt(),
  outputTotalFrames: (json['outputTotalFrames'] as num).toInt(),
);

Map<String, dynamic> _$StreamStatusResponseToJson(
  StreamStatusResponse instance,
) => <String, dynamic>{
  'outputActive': instance.outputActive,
  'outputReconnecting': instance.outputReconnecting,
  'outputTimecode': instance.outputTimecode,
  'outputDuration': instance.outputDuration,
  'outputCongestion': instance.outputCongestion,
  'outputBytes': instance.outputBytes,
  'outputSkippedFrames': instance.outputSkippedFrames,
  'outputTotalFrames': instance.outputTotalFrames,
};
