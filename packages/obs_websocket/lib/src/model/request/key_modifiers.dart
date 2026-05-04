import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'key_modifiers.g.dart';

@JsonSerializable()
class KeyModifiers {
  /// Press Shift
  final bool? shift;

  /// Press CTRL
  final bool? control;

  /// Press ALT
  final bool? alt;

  /// Press CMD (Mac)
  final bool? command;

  KeyModifiers({this.shift, this.control, this.alt, this.command});

  factory KeyModifiers.fromJson(Map<String, dynamic> json) =>
      _$KeyModifiersFromJson(json);

  Map<String, dynamic> toJson() => _$KeyModifiersToJson(this);

  @override
  String toString() => json.encode(toJson());
}
