import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'create_input_response.g.dart';

@JsonSerializable()
class CreateInputResponse {
  /// UUID of the newly created input
  final String inputUuid;

  /// r	ID of the newly created scene item
  final int sceneItemId;

  CreateInputResponse({required this.inputUuid, required this.sceneItemId});

  factory CreateInputResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateInputResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateInputResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
