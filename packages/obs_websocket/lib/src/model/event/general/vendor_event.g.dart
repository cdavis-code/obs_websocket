// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorEvent _$VendorEventFromJson(Map<String, dynamic> json) => VendorEvent(
  vendorName: json['vendorName'] as String,
  eventType: json['eventType'] as String,
  eventData: json['eventData'] as Map<String, dynamic>,
);

Map<String, dynamic> _$VendorEventToJson(VendorEvent instance) =>
    <String, dynamic>{
      'vendorName': instance.vendorName,
      'eventType': instance.eventType,
      'eventData': instance.eventData,
    };
