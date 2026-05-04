import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'record_status_response.g.dart';

@JsonSerializable()
class RecordStatusResponse {
  final bool outputActive;
  final bool outputPaused;
  final String outputTimecode;
  final int outputDuration;
  final int outputBytes;

  RecordStatusResponse({
    required this.outputActive,
    required this.outputPaused,
    required this.outputTimecode,
    required this.outputDuration,
    required this.outputBytes,
  });

  factory RecordStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$RecordStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecordStatusResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
