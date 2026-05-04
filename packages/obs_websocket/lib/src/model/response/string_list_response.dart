import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'string_list_response.g.dart';

@JsonSerializable()
class StringListResponse {
  final List<String>? hotkeys;
  final List<String>? groups;
  final List<String>? inputKinds;

  List<String> get items {
    final List<String>? check = hotkeys ?? groups;

    if (check == null) throw Exception();

    return check;
  }

  StringListResponse({this.hotkeys, this.groups, this.inputKinds});

  factory StringListResponse.fromJson(Map<String, dynamic> json) =>
      _$StringListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StringListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
