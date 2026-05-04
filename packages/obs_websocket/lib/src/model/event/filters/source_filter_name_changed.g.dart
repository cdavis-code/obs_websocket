// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_filter_name_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceFilterNameChanged _$SourceFilterNameChangedFromJson(
  Map<String, dynamic> json,
) => SourceFilterNameChanged(
  sourceName: json['sourceName'] as String,
  oldFilterName: json['oldFilterName'] as String,
  filterName: json['filterName'] as String,
);

Map<String, dynamic> _$SourceFilterNameChangedToJson(
  SourceFilterNameChanged instance,
) => <String, dynamic>{
  'sourceName': instance.sourceName,
  'oldFilterName': instance.oldFilterName,
  'filterName': instance.filterName,
};
