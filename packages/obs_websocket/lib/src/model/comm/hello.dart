import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'authentication.dart';

part 'hello.g.dart';

@JsonSerializable()
class Hello {
  final String obsWebSocketVersion;

  final int rpcVersion;

  final Authentication? authentication;

  Hello({
    required this.obsWebSocketVersion,
    required this.rpcVersion,
    this.authentication,
  });

  factory Hello.fromJson(Map<String, dynamic> json) => _$HelloFromJson(json);

  Map<String, dynamic> toJson() => _$HelloToJson(this);

  @override
  String toString() => json.encode(toJson());
}
