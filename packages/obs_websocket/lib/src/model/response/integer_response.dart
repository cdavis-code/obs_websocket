import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'integer_response.g.dart';

/// Maps to a integer response form the websocket.  `int?` fields are added to the class for each Response type needed.
@JsonSerializable()
class IntegerResponse {
  final int? sceneItemId;
  final int? sceneItemIndex;

  int get itemId {
    var id = sceneItemId ?? sceneItemIndex;

    if (id == null) {
      throw Exception();
    }

    return id;
  }

  IntegerResponse({this.sceneItemId, this.sceneItemIndex});

  factory IntegerResponse.fromJson(Map<String, dynamic> json) =>
      _$IntegerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IntegerResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
