// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_filter_settings_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceFilterSettingsChanged _$SourceFilterSettingsChangedFromJson(
  Map<String, dynamic> json,
) => SourceFilterSettingsChanged(
  sourceName: json['sourceName'] as String,
  filterName: json['filterName'] as String,
  filterSettings: json['filterSettings'] as Map<String, dynamic>,
);

Map<String, dynamic> _$SourceFilterSettingsChangedToJson(
  SourceFilterSettingsChanged instance,
) => <String, dynamic>{
  'sourceName': instance.sourceName,
  'filterName': instance.filterName,
  'filterSettings': instance.filterSettings,
};
