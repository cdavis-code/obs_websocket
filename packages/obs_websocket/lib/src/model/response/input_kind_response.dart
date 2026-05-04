import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'input.dart';

part 'input_kind_response.g.dart';

@JsonSerializable()
class InputKindResponse {
  final List<Input> inputs;

  InputKindResponse({required this.inputs});

  factory InputKindResponse.fromJson(Map<String, dynamic> json) =>
      _$InputKindResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputKindResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
