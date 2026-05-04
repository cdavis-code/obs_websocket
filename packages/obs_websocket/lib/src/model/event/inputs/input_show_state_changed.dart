import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_show_state_changed.g.dart';

/// An input's show state has changed.
///
/// When an input is showing, it means it's being shown by the preview or a dialog.
///
/// Complexity Rating: 3/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputShowStateChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// Whether the input is showing
  final bool videoShowing;

  InputShowStateChanged({
    required this.inputName,
    required this.inputUuid,
    required this.videoShowing,
  });

  factory InputShowStateChanged.fromJson(Map<String, dynamic> json) =>
      _$InputShowStateChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputShowStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
