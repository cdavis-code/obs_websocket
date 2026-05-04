import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_removed.g.dart';

/// An input has been removed.
///
/// Complexity Rating: 2/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputRemoved implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  InputRemoved({required this.inputName, required this.inputUuid});

  factory InputRemoved.fromJson(Map<String, dynamic> json) =>
      _$InputRemovedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputRemovedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
