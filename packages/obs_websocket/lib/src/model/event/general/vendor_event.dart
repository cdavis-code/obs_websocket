import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'vendor_event.g.dart';

@JsonSerializable()
class VendorEvent implements BaseEvent {
  final String vendorName;
  final String eventType;
  final Map<String, dynamic> eventData;

  VendorEvent({
    required this.vendorName,
    required this.eventType,
    required this.eventData,
  });

  factory VendorEvent.fromJson(Map<String, dynamic> json) =>
      _$VendorEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VendorEventToJson(this);

  @override
  String toString() => json.encode(toJson());
}
