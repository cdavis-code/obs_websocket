import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/src/model/response/call_vendor_request_data.dart';

part 'call_vendor_request_response.g.dart';

/// A vendor is a unique name registered by a third-party plugin or script,
/// which allows for custom requests and events to be added to obs-websocket. If
/// a plugin or script implements vendor requests or events, documentation is
/// expected to be provided with them.
@JsonSerializable()
class CallVendorRequestResponse {
  final String vendorName;
  final String requestType;
  final RequestData? requestData;

  CallVendorRequestResponse({
    required this.vendorName,
    required this.requestType,
    this.requestData,
  });

  factory CallVendorRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$CallVendorRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CallVendorRequestResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
