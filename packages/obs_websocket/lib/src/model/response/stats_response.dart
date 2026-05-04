import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stats_response.g.dart';

@JsonSerializable()
class StatsResponse {
  final num cpuUsage;
  final num memoryUsage;
  final num availableDiskSpace;
  final num activeFps;
  final num averageFrameRenderTime;
  final num renderSkippedFrames;
  final num renderTotalFrames;
  final num outputSkippedFrames;
  final num outputTotalFrames;
  final num webSocketSessionIncomingMessages;
  final num webSocketSessionOutgoingMessages;

  StatsResponse({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.availableDiskSpace,
    required this.activeFps,
    required this.averageFrameRenderTime,
    required this.renderSkippedFrames,
    required this.renderTotalFrames,
    required this.outputSkippedFrames,
    required this.outputTotalFrames,
    required this.webSocketSessionIncomingMessages,
    required this.webSocketSessionOutgoingMessages,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) =>
      _$StatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
