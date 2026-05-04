import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_created.g.dart';

/// An input has been created.
///
/// Complexity Rating: 2/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputCreated implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// The kind of the input
  final String inputKind;

  /// The unversioned kind of input (aka no _v2 stuff)
  final String inputKindUnversioned;

  /// Bitwise flag value for the caps that an input supports. See obs_source_info.output_flags in the libobs docs
  final int inputKindCaps;

  /// The settings configured to the input when it was created
  final Map<String, dynamic> inputSettings;

  /// The default settings for the input
  final Map<String, dynamic> defaultInputSettings;

  InputCreated({
    required this.inputName,
    required this.inputUuid,
    required this.inputKind,
    required this.inputKindUnversioned,
    required this.inputKindCaps,
    required this.inputSettings,
    required this.defaultInputSettings,
  });

  factory InputCreated.fromJson(Map<String, dynamic> json) =>
      _$InputCreatedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputCreatedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
