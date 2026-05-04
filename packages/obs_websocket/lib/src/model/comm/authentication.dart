import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

@JsonSerializable()
class Authentication {
  final String challenge;
  final String salt;

  Authentication({required this.challenge, required this.salt});

  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationToJson(this);

  @override
  String toString() => json.encode(toJson());
}
