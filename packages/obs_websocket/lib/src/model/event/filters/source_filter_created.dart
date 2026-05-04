import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'source_filter_created.g.dart';

/// A filter has been added to a source.
@JsonSerializable()
class SourceFilterCreated implements BaseEvent {
  /// Name of the source the filter was added to
  final String sourceName;

  /// Name of the filter
  final String filterName;

  /// The kind of the filter
  final String filterKind;

  /// Index position of the filter
  final int filterIndex;

  /// The settings configured to the filter when it was created
  final Map<String, dynamic> filterSettings;

  /// The default settings for the filter
  final Map<String, dynamic> defaultFilterSettings;

  SourceFilterCreated({
    required this.sourceName,
    required this.filterName,
    required this.filterKind,
    required this.filterIndex,
    required this.filterSettings,
    required this.defaultFilterSettings,
  });

  factory SourceFilterCreated.fromJson(Map<String, dynamic> json) =>
      _$SourceFilterCreatedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SourceFilterCreatedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
