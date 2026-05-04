import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'request_status.g.dart';

@JsonSerializable()
class RequestStatus {
  final bool result;
  final int code;
  final String? comment;

  RequestStatus({
    required this.result,
    required this.code,
    required this.comment,
  });

  factory RequestStatus.fromJson(Map<String, dynamic> json) =>
      _$RequestStatusFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStatusToJson(this);

  @override
  String toString() => json.encode(toJson());
}
