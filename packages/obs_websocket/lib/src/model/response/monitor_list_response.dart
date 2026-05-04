import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../shared/monitor.dart';

part 'monitor_list_response.g.dart';

@JsonSerializable()
class MonitorListResponse {
  final List<Monitor> monitors;

  MonitorListResponse({required this.monitors});

  factory MonitorListResponse.fromJson(Map<String, dynamic> json) =>
      _$MonitorListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
