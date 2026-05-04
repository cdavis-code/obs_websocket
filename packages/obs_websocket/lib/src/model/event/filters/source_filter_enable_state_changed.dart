import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'source_filter_enable_state_changed.g.dart';

/// A source filter's enable state has changed.
@JsonSerializable()
class SourceFilterEnableStateChanged implements BaseEvent {
  /// Name of the source the filter is on
  final String sourceName;

  /// Name of the filter
  final String filterName;

  /// Whether the filter is enabled
  final bool filterEnabled;

  /// Creates an event for when a source filter's enabled state changes.
  SourceFilterEnableStateChanged({
    required this.sourceName,
    required this.filterName,
    required this.filterEnabled,
  });

  /// Creates an event from a JSON map.
  factory SourceFilterEnableStateChanged.fromJson(Map<String, dynamic> json) =>
      _$SourceFilterEnableStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$SourceFilterEnableStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
