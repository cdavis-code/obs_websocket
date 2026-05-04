import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input_audio_balance_response.g.dart';

/// Response for GetInputAudioBalance request
@JsonSerializable()
class InputAudioBalanceResponse {
  /// Balance of the input (0.0 to 1.0, where 0.0 is left, 0.5 is center, 1.0 is right)
  final double inputAudioBalance;

  InputAudioBalanceResponse({required this.inputAudioBalance});

  factory InputAudioBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$InputAudioBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputAudioBalanceResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
