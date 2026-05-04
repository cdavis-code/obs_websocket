// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_batch_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestBatchResponse _$RequestBatchResponseFromJson(
  Map<String, dynamic> json,
) => RequestBatchResponse(
  requestId: json['requestId'] as String,
  results: (json['results'] as List<dynamic>)
      .map((e) => RequestResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RequestBatchResponseToJson(
  RequestBatchResponse instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'results': instance.results,
};
