// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsResponse _$StatsResponseFromJson(Map<String, dynamic> json) =>
    StatsResponse(
      cpuUsage: json['cpuUsage'] as num,
      memoryUsage: json['memoryUsage'] as num,
      availableDiskSpace: json['availableDiskSpace'] as num,
      activeFps: json['activeFps'] as num,
      averageFrameRenderTime: json['averageFrameRenderTime'] as num,
      renderSkippedFrames: json['renderSkippedFrames'] as num,
      renderTotalFrames: json['renderTotalFrames'] as num,
      outputSkippedFrames: json['outputSkippedFrames'] as num,
      outputTotalFrames: json['outputTotalFrames'] as num,
      webSocketSessionIncomingMessages:
          json['webSocketSessionIncomingMessages'] as num,
      webSocketSessionOutgoingMessages:
          json['webSocketSessionOutgoingMessages'] as num,
    );

Map<String, dynamic> _$StatsResponseToJson(
  StatsResponse instance,
) => <String, dynamic>{
  'cpuUsage': instance.cpuUsage,
  'memoryUsage': instance.memoryUsage,
  'availableDiskSpace': instance.availableDiskSpace,
  'activeFps': instance.activeFps,
  'averageFrameRenderTime': instance.averageFrameRenderTime,
  'renderSkippedFrames': instance.renderSkippedFrames,
  'renderTotalFrames': instance.renderTotalFrames,
  'outputSkippedFrames': instance.outputSkippedFrames,
  'outputTotalFrames': instance.outputTotalFrames,
  'webSocketSessionIncomingMessages': instance.webSocketSessionIncomingMessages,
  'webSocketSessionOutgoingMessages': instance.webSocketSessionOutgoingMessages,
};
