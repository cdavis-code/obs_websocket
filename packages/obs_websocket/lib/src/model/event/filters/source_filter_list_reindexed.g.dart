// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_filter_list_reindexed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceFilterListReindexed _$SourceFilterListReindexedFromJson(
  Map<String, dynamic> json,
) => SourceFilterListReindexed(
  sourceName: json['sourceName'] as String,
  filters: (json['filters'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$SourceFilterListReindexedToJson(
  SourceFilterListReindexed instance,
) => <String, dynamic>{
  'sourceName': instance.sourceName,
  'filters': instance.filters,
};
