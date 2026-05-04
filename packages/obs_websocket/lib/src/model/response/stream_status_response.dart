import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stream_status_response.g.dart';

@JsonSerializable()
class StreamStatusResponse {
  final bool outputActive;
  final bool outputReconnecting;
  final String outputTimecode;
  final int outputDuration;
  final double outputCongestion;
  final int outputBytes;
  final int outputSkippedFrames;
  final int outputTotalFrames;

  StreamStatusResponse({
    required this.outputActive,
    required this.outputReconnecting,
    required this.outputTimecode,
    required this.outputDuration,
    required this.outputCongestion,
    required this.outputBytes,
    required this.outputSkippedFrames,
    required this.outputTotalFrames,
  });

  factory StreamStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$StreamStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StreamStatusResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
