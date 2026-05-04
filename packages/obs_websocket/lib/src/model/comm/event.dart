// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show EventOpcode, Opcode;

part 'event.g.dart';

@JsonSerializable()
class Event {
  final String eventType;
  final int eventIntent;
  final Map<String, dynamic>? eventData;

  Event({
    required this.eventType,
    required this.eventIntent,
    required this.eventData,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Opcode toOpcode() => EventOpcode(this);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  String toString() => json.encode(toJson());
}
