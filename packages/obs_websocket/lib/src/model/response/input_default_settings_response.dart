import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input_default_settings_response.g.dart';

@JsonSerializable()
class InputDefaultSettingsResponse {
  /// Object of default settings for the input kind
  final Map<String, dynamic> defaultInputSettings;

  InputDefaultSettingsResponse({required this.defaultInputSettings});

  factory InputDefaultSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$InputDefaultSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputDefaultSettingsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
