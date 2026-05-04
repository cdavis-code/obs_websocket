import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'studio_mode_state_changed.g.dart';

/// Studio mode has been enabled or disabled.
@JsonSerializable()
class StudioModeStateChanged implements BaseEvent {
  /// True == Enabled, False == Disabled
  final bool studioModeEnabled;

  StudioModeStateChanged({required this.studioModeEnabled});

  factory StudioModeStateChanged.fromJson(Map<String, dynamic> json) =>
      _$StudioModeStateChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StudioModeStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
