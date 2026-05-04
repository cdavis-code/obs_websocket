// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_vendor_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestData _$RequestDataFromJson(Map<String, dynamic> json) => RequestData(
  eventName: json['event_name'] as String,
  eventData: json['event_data'],
);

Map<String, dynamic> _$RequestDataToJson(RequestData instance) =>
    <String, dynamic>{
      'event_name': instance.eventName,
      'event_data': instance.eventData,
    };
