// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_vendor_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallVendorRequestResponse _$CallVendorRequestResponseFromJson(
  Map<String, dynamic> json,
) => CallVendorRequestResponse(
  vendorName: json['vendorName'] as String,
  requestType: json['requestType'] as String,
  requestData: json['requestData'] == null
      ? null
      : RequestData.fromJson(json['requestData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallVendorRequestResponseToJson(
  CallVendorRequestResponse instance,
) => <String, dynamic>{
  'vendorName': instance.vendorName,
  'requestType': instance.requestType,
  'requestData': instance.requestData,
};
