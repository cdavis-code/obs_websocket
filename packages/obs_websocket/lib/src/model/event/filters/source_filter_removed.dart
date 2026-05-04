import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'source_filter_removed.g.dart';

/// A filter has been removed from a source.
@JsonSerializable()
class SourceFilterRemoved implements BaseEvent {
  /// Name of the source the filter was removed from
  final String sourceName;

  /// Name of the filter
  final String filterName;

  SourceFilterRemoved({required this.sourceName, required this.filterName});

  factory SourceFilterRemoved.fromJson(Map<String, dynamic> json) =>
      _$SourceFilterRemovedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SourceFilterRemovedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
