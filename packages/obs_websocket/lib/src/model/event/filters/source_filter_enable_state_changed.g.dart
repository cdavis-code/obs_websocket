// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_filter_enable_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceFilterEnableStateChanged _$SourceFilterEnableStateChangedFromJson(
  Map<String, dynamic> json,
) => SourceFilterEnableStateChanged(
  sourceName: json['sourceName'] as String,
  filterName: json['filterName'] as String,
  filterEnabled: json['filterEnabled'] as bool,
);

Map<String, dynamic> _$SourceFilterEnableStateChangedToJson(
  SourceFilterEnableStateChanged instance,
) => <String, dynamic>{
  'sourceName': instance.sourceName,
  'filterName': instance.filterName,
  'filterEnabled': instance.filterEnabled,
};
