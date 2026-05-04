import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'opcode.dart';

part 'request.g.dart';

@JsonSerializable(createToJson: false)
class Request {
  final String requestType;
  final String requestId;
  final Map<String, dynamic>? requestData;
  bool? expectResponse;

  bool get hasResponseData => expectResponse!;

  Request(this.requestType, {this.requestData, this.expectResponse})
    : requestId = Uuid().v4() {
    expectResponse ??= requestType.startsWith('Get');
  }

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Opcode toOpcode() => RequestOpcode(this);

  Map<String, dynamic> toJson() => {
    'requestType': requestType,
    'requestId': requestId,
    'requestData': requestData,
  }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.encode(toJson());
}
