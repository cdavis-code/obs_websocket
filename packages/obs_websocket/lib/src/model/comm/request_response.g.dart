// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestResponse _$RequestResponseFromJson(Map<String, dynamic> json) =>
    RequestResponse(
      requestType: json['requestType'] as String,
      requestId: json['requestId'] as String,
      requestStatus: RequestStatus.fromJson(
        json['requestStatus'] as Map<String, dynamic>,
      ),
      responseData: json['responseData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RequestResponseToJson(RequestResponse instance) =>
    <String, dynamic>{
      'requestType': instance.requestType,
      'requestId': instance.requestId,
      'requestStatus': instance.requestStatus,
      'responseData': instance.responseData,
    };
