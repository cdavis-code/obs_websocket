// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
  json['requestType'] as String,
  requestData: json['requestData'] as Map<String, dynamic>?,
  expectResponse: json['expectResponse'] as bool?,
);
