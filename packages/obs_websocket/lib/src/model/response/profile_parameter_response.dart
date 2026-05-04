import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'profile_parameter_response.g.dart';

/// Gets the current directory that the record output is set to.
@JsonSerializable()
class ProfileParameterResponse {
  final String parameterValue;
  final String defaultParameterValue;

  ProfileParameterResponse({
    required this.parameterValue,
    required this.defaultParameterValue,
  });

  factory ProfileParameterResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileParameterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileParameterResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
