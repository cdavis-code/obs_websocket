import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show IdentifyOpcode, Opcode;

part 'identify.g.dart';

@JsonSerializable()
class Identify {
  final int rpcVersion;

  final String? authentication;

  final int? eventSubscriptions;

  Identify({
    required this.rpcVersion,
    this.authentication,
    this.eventSubscriptions,
  });

  factory Identify.fromJson(Map<String, dynamic> json) =>
      _$IdentifyFromJson(json);

  Opcode toOpcode() => IdentifyOpcode(this);

  Map<String, dynamic> toJson() => _$IdentifyToJson(this);

  @override
  String toString() => json.encode(toJson());
}
