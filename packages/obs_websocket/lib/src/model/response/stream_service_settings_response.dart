import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stream_service_settings_response.g.dart';

@JsonSerializable()
class StreamServiceSettingsResponse {
  final String streamServiceType;
  final String streamServiceSettings;

  StreamServiceSettingsResponse({
    required this.streamServiceType,
    required this.streamServiceSettings,
  });

  factory StreamServiceSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$StreamServiceSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StreamServiceSettingsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
