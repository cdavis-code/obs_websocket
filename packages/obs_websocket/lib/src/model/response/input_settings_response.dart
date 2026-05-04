import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input_settings_response.g.dart';

@JsonSerializable()
class InputSettingsResponse {
  /// Object of default settings for the input kind
  final Map<String, dynamic> inputSettings;

  /// The kind of the input
  final String inputKind;

  InputSettingsResponse({required this.inputSettings, required this.inputKind});

  factory InputSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$InputSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputSettingsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
