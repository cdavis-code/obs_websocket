import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_name_changed.g.dart';

/// The name of an input has changed.
///
/// Complexity Rating: 2/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputNameChanged implements BaseEvent {
  /// UUID of the input
  final String inputUuid;

  /// Old name of the input
  final String oldInputName;

  /// New name of the input
  final String inputName;

  InputNameChanged({
    required this.inputUuid,
    required this.oldInputName,
    required this.inputName,
  });

  factory InputNameChanged.fromJson(Map<String, dynamic> json) =>
      _$InputNameChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputNameChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
