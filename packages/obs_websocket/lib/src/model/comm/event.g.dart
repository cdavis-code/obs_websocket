// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  eventType: json['eventType'] as String,
  eventIntent: (json['eventIntent'] as num).toInt(),
  eventData: json['eventData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'eventType': instance.eventType,
  'eventIntent': instance.eventIntent,
  'eventData': instance.eventData,
};
