import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'call_vendor_request_data.g.dart';

/// A vendor is a unique name registered by a third-party plugin or script,
/// which allows for custom requests and events to be added to obs-websocket. If
/// a plugin or script implements vendor requests or events, documentation is
/// expected to be provided with them.
@JsonSerializable()
class RequestData {
  @JsonKey(name: 'event_name')
  final String eventName;

  @JsonKey(name: 'event_data')
  dynamic eventData;

  RequestData({required this.eventName, this.eventData});

  factory RequestData.fromJson(Map<String, dynamic> json) =>
      _$RequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDataToJson(this);

  @override
  String toString() => json.encode(toJson());
}
