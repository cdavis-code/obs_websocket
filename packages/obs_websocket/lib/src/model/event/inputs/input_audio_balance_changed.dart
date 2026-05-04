import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'input_audio_balance_changed.g.dart';

/// The audio balance value of an input has changed.
///
/// Complexity Rating: 2/5
/// Latest Supported RPC Version: 1
/// Added in v5.0.0

@JsonSerializable()
class InputAudioBalanceChanged implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String inputUuid;

  /// New audio balance value of the input
  final double inputAudioBalance;

  InputAudioBalanceChanged({
    required this.inputName,
    required this.inputUuid,
    required this.inputAudioBalance,
  });

  factory InputAudioBalanceChanged.fromJson(Map<String, dynamic> json) =>
      _$InputAudioBalanceChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputAudioBalanceChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
