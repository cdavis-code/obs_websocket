// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionResponse _$VersionResponseFromJson(Map<String, dynamic> json) =>
    VersionResponse(
      obsVersion: json['obsVersion'] as String,
      obsWebSocketVersion: json['obsWebSocketVersion'] as String,
      rpcVersion: (json['rpcVersion'] as num).toInt(),
      availableRequests: (json['availableRequests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      supportedImageFormats: (json['supportedImageFormats'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      platform: json['platform'] as String,
      platformDescription: json['platformDescription'] as String,
    );

Map<String, dynamic> _$VersionResponseToJson(VersionResponse instance) =>
    <String, dynamic>{
      'obsVersion': instance.obsVersion,
      'obsWebSocketVersion': instance.obsWebSocketVersion,
      'rpcVersion': instance.rpcVersion,
      'availableRequests': instance.availableRequests,
      'supportedImageFormats': instance.supportedImageFormats,
      'platform': instance.platform,
      'platformDescription': instance.platformDescription,
    };
