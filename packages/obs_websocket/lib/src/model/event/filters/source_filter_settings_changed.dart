import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'source_filter_settings_changed.g.dart';

/// A source filter's settings have changed.
///
/// Added in v5.5.0
@JsonSerializable()
class SourceFilterSettingsChanged implements BaseEvent {
  /// Name of the source the filter is on
  final String sourceName;

  /// Name of the filter
  final String filterName;

  /// New settings object of the filter
  final Map<String, dynamic> filterSettings;

  SourceFilterSettingsChanged({
    required this.sourceName,
    required this.filterName,
    required this.filterSettings,
  });

  factory SourceFilterSettingsChanged.fromJson(Map<String, dynamic> json) =>
      _$SourceFilterSettingsChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SourceFilterSettingsChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
