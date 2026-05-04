import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'source_filter_name_changed.g.dart';

/// The name of a source filter has changed.
@JsonSerializable()
class SourceFilterNameChanged implements BaseEvent {
  /// Name of the source the filter is on
  final String sourceName;

  /// Old name of the filter
  final String oldFilterName;

  /// New name of the filter
  final String filterName;

  SourceFilterNameChanged({
    required this.sourceName,
    required this.oldFilterName,
    required this.filterName,
  });

  factory SourceFilterNameChanged.fromJson(Map<String, dynamic> json) =>
      _$SourceFilterNameChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SourceFilterNameChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
