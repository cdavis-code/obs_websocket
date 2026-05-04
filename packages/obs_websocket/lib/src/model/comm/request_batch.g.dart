// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestBatch _$RequestBatchFromJson(Map<String, dynamic> json) => RequestBatch(
  haltOnFailure: json['haltOnFailure'] as bool? ?? false,
  executionType:
      $enumDecodeNullable(
        _$RequestBatchExecutionTypeEnumMap,
        json['executionType'],
      ) ??
      RequestBatchExecutionType.serialRealtime,
  requests: (json['requests'] as List<dynamic>)
      .map((e) => Request.fromJson(e as Map<String, dynamic>))
      .toList(),
);

const _$RequestBatchExecutionTypeEnumMap = {
  RequestBatchExecutionType.none: 'none',
  RequestBatchExecutionType.serialRealtime: 'serialRealtime',
  RequestBatchExecutionType.serialFrame: 'serialFrame',
  RequestBatchExecutionType.parallel: 'parallel',
};
