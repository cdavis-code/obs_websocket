// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestStatus _$RequestStatusFromJson(Map<String, dynamic> json) =>
    RequestStatus(
      result: json['result'] as bool,
      code: (json['code'] as num).toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$RequestStatusToJson(RequestStatus instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'comment': instance.comment,
    };
