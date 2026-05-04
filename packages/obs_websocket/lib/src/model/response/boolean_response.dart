import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'boolean_response.g.dart';

/// Maps to a boolean response form the websocket.  `bool?` fields are added to the class for each Response type needed.
@JsonSerializable()
class BooleanResponse {
  final bool? outputActive;
  final bool? sceneItemEnabled;
  final bool? studioModeEnabled;
  final bool? inputMuted;
  final bool? sceneItemLocked;

  bool get enabled {
    final bool? check =
        outputActive ??
        sceneItemEnabled ??
        studioModeEnabled ??
        inputMuted ??
        sceneItemLocked;

    if (check == null) throw Exception();

    return check;
  }

  BooleanResponse({
    this.outputActive,
    this.sceneItemEnabled,
    this.studioModeEnabled,
    this.inputMuted,
    this.sceneItemLocked,
  });

  factory BooleanResponse.fromJson(Map<String, dynamic> json) =>
      _$BooleanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BooleanResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
