import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'custom_event.g.dart';

/// Custom event emitted by BroadcastCustomEvent.
@JsonSerializable()
class CustomEvent implements BaseEvent {
  /// Custom event data
  final Map<String, dynamic> eventData;

  CustomEvent({required this.eventData});

  factory CustomEvent.fromJson(Map<String, dynamic> json) =>
      _$CustomEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomEventToJson(this);

  @override
  String toString() => json.encode(toJson());
}
