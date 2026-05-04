import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/src/util/enum.dart';
import 'package:uuid/uuid.dart';

import 'opcode.dart';
import 'request.dart';

part 'request_batch.g.dart';

@JsonSerializable(createToJson: false)
class RequestBatch {
  final bool haltOnFailure;
  final String requestId;
  final RequestBatchExecutionType executionType;
  final List<Request> requests;

  RequestBatch({
    this.haltOnFailure = false,
    this.executionType = RequestBatchExecutionType.serialRealtime,
    required this.requests,
  }) : requestId = Uuid().v4();

  factory RequestBatch.fromJson(Map<String, dynamic> json) =>
      _$RequestBatchFromJson(json);

  Opcode toOpcode() => RequestBatchOpcode(this);

  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'haltOnFailure': haltOnFailure,
    'executionType': executionType.code,
    'requests': requests.map((request) => request.toJson()).toList(),
  };

  @override
  String toString() => json.encode(toJson());
}
