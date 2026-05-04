// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Identify _$IdentifyFromJson(Map<String, dynamic> json) => Identify(
  rpcVersion: (json['rpcVersion'] as num).toInt(),
  authentication: json['authentication'] as String?,
  eventSubscriptions: (json['eventSubscriptions'] as num?)?.toInt(),
);

Map<String, dynamic> _$IdentifyToJson(Identify instance) => <String, dynamic>{
  'rpcVersion': instance.rpcVersion,
  'authentication': instance.authentication,
  'eventSubscriptions': instance.eventSubscriptions,
};
