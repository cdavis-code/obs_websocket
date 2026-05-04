import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input.g.dart';

@JsonSerializable()
class Input {
  final String inputKind;
  final String inputName;
  final String unversionedInputKind;

  Input({
    required this.inputKind,
    required this.inputName,
    required this.unversionedInputKind,
  });

  factory Input.fromJson(Map<String, dynamic> json) => _$InputFromJson(json);

  Map<String, dynamic> toJson() => _$InputToJson(this);

  @override
  String toString() => json.encode(toJson());
}
