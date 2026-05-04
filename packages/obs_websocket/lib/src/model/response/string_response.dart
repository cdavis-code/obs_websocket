import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'string_response.g.dart';

/// Maps to a string response form the websocket.  `string?` fields are added to the class for each Response type needed.
@JsonSerializable()
class StringResponse {
  final String? outputPath;
  final String? currentProgramSceneName;
  final String? currentPreviewSceneName;

  String get value {
    final String? check =
        outputPath ?? currentProgramSceneName ?? currentPreviewSceneName;

    if (check == null) throw Exception();

    return check;
  }

  StringResponse({
    this.outputPath,
    this.currentProgramSceneName,
    this.currentPreviewSceneName,
  });

  factory StringResponse.fromJson(Map<String, dynamic> json) =>
      _$StringResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StringResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
