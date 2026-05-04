import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'version_response.g.dart';

@JsonSerializable()
class VersionResponse {
  final String obsVersion;
  final String obsWebSocketVersion;
  final int rpcVersion;
  final List<String> availableRequests;
  final List<String> supportedImageFormats;
  final String platform;
  final String platformDescription;

  VersionResponse({
    required this.obsVersion,
    required this.obsWebSocketVersion,
    required this.rpcVersion,
    required this.availableRequests,
    required this.supportedImageFormats,
    required this.platform,
    required this.platformDescription,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VersionResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
