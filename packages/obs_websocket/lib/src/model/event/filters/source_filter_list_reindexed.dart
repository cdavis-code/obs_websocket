import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'source_filter_list_reindexed.g.dart';

/// A source's filter list has been reindexed.
@JsonSerializable()
class SourceFilterListReindexed implements BaseEvent {
  /// Name of the source
  final String sourceName;

  /// Array of filter objects (with filterName and filterIndex)
  final List<Map<String, dynamic>> filters;

  SourceFilterListReindexed({required this.sourceName, required this.filters});

  factory SourceFilterListReindexed.fromJson(Map<String, dynamic> json) =>
      _$SourceFilterListReindexedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SourceFilterListReindexedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
