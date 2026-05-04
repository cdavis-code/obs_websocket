import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_settings_changed.g.dart';

/// An input's settings have changed (been updated).
///
/// Note: On some inputs, changing values in the properties dialog will cause an immediate update. Pressing the "Cancel" button will revert the settings, resulting in another event being fired.
///
/// Complexity Rating: 3/5
/// Latest Supported RPC Version: 1
/// Added in v5.4.0

@JsonSerializable()
class InputSettingsChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// New settings object of the input
  final Map<String, dynamic> inputSettings;

  InputSettingsChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputSettings,
  });

  factory InputSettingsChanged.fromJson(Map<String, dynamic> json) =>
      _$InputSettingsChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputSettingsChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
