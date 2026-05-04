import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'input_volume_response.g.dart';

@JsonSerializable()
class InputVolumeResponse {
  final double inputVolumeMul;
  final double inputVolumeDb;

  InputVolumeResponse({
    required this.inputVolumeMul,
    required this.inputVolumeDb,
  });

  factory InputVolumeResponse.fromJson(Map<String, dynamic> json) =>
      _$InputVolumeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InputVolumeResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
