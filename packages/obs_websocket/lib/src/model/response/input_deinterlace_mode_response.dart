import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/src/enum/obs_deinterlace_mode.dart';

part 'input_deinterlace_mode_response.g.dart';

@JsonSerializable()
class InputDeinterlaceModeResponse {
  @JsonKey(unknownEnumValue: ObsDeinterlaceMode.disable)
  final ObsDeinterlaceMode deinterlaceMode;

  InputDeinterlaceModeResponse({required this.deinterlaceMode});

  factory InputDeinterlaceModeResponse.fromJson(Map<String, dynamic> json) =>
      _$InputDeinterlaceModeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputDeinterlaceModeResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
