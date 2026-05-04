import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'identified.g.dart';

@JsonSerializable()
class Identified {
  final int negotiatedRpcVersion;

  Identified({required this.negotiatedRpcVersion});

  factory Identified.fromJson(Map<String, dynamic> json) =>
      _$IdentifiedFromJson(json);

  Map<String, dynamic> toJson() => _$IdentifiedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
