// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_filter_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceFilterCreated _$SourceFilterCreatedFromJson(Map<String, dynamic> json) =>
    SourceFilterCreated(
      sourceName: json['sourceName'] as String,
      filterName: json['filterName'] as String,
      filterKind: json['filterKind'] as String,
      filterIndex: (json['filterIndex'] as num).toInt(),
      filterSettings: json['filterSettings'] as Map<String, dynamic>,
      defaultFilterSettings:
          json['defaultFilterSettings'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SourceFilterCreatedToJson(
  SourceFilterCreated instance,
) => <String, dynamic>{
  'sourceName': instance.sourceName,
  'filterName': instance.filterName,
  'filterKind': instance.filterKind,
  'filterIndex': instance.filterIndex,
  'filterSettings': instance.filterSettings,
  'defaultFilterSettings': instance.defaultFilterSettings,
};
