import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show RequestResponse;

part 'request_batch_response.g.dart';

@JsonSerializable()
class RequestBatchResponse {
  final String requestId;
  final List<RequestResponse> results;

  RequestBatchResponse({required this.requestId, required this.results});

  factory RequestBatchResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestBatchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestBatchResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
