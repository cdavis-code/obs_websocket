// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hello _$HelloFromJson(Map<String, dynamic> json) => Hello(
  obsWebSocketVersion: json['obsWebSocketVersion'] as String,
  rpcVersion: (json['rpcVersion'] as num).toInt(),
  authentication: json['authentication'] == null
      ? null
      : Authentication.fromJson(json['authentication'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HelloToJson(Hello instance) => <String, dynamic>{
  'obsWebSocketVersion': instance.obsWebSocketVersion,
  'rpcVersion': instance.rpcVersion,
  'authentication': instance.authentication,
};
