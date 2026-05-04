import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'request_status.dart';

part 'request_response.g.dart';

@JsonSerializable()
class RequestResponse {
  final String requestType;
  final String requestId;
  final RequestStatus requestStatus;
  final Map<String, dynamic>? responseData;

  RequestResponse({
    required this.requestType,
    required this.requestId,
    required this.requestStatus,
    this.responseData,
  });

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
