import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'studio_mode_state_changed.g.dart';

/// Studio mode has been enabled or disabled.
@JsonSerializable()
class StudioModeStateChanged implements BaseEvent {
  /// True == Enabled, False == Disabled
  final bool studioModeEnabled;

  /// Creates an event for when studio mode state changes.
  StudioModeStateChanged({required this.studioModeEnabled});

  /// Creates an event from a JSON map.
  factory StudioModeStateChanged.fromJson(Map<String, dynamic> json) =>
      _$StudioModeStateChangedFromJson(json);

  /// Converts the event to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$StudioModeStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
