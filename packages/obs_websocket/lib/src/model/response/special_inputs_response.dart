import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'special_inputs_response.g.dart';

@JsonSerializable()
class SpecialInputsResponse {
  /// Name of the Desktop Audio input
  final String? desktop1;

  /// Name of the Desktop Audio 2 input
  final String? desktop2;

  /// Name of the Mic/Auxiliary Audio input
  final String? mic1;

  /// Name of the Mic/Auxiliary Audio 2 input
  final String? mic2;

  ///	Name of the Mic/Auxiliary Audio 3 input
  final String? mic3;

  /// Name of the Mic/Auxiliary Audio 4 input
  final String? mic4;

  SpecialInputsResponse({
    this.desktop1,
    this.desktop2,
    this.mic1,
    this.mic2,
    this.mic3,
    this.mic4,
  });

  factory SpecialInputsResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialInputsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialInputsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
