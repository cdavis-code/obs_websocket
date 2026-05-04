import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'monitor.g.dart';

@JsonSerializable()
class Monitor {
  final int monitorHeight;
  final int monitorIndex;
  final String monitorName;
  final int monitorPositionX;
  final int monitorPositionY;
  final int monitorWidth;

  Monitor({
    required this.monitorHeight,
    required this.monitorIndex,
    required this.monitorName,
    required this.monitorPositionX,
    required this.monitorPositionY,
    required this.monitorWidth,
  });

  factory Monitor.fromJson(Map<String, dynamic> json) =>
      _$MonitorFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorToJson(this);

  @override
  String toString() => json.encode(toJson());
}
