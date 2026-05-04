import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show ReIdentifyOpcode, Opcode;

part 'reidentify.g.dart';

@JsonSerializable()
class ReIdentify {
  final int? eventSubscriptions;

  ReIdentify({this.eventSubscriptions});

  factory ReIdentify.fromJson(Map<String, dynamic> json) =>
      _$ReIdentifyFromJson(json);

  Opcode toOpcode() => ReIdentifyOpcode(this);

  Map<String, dynamic> toJson() => _$ReIdentifyToJson(this);

  @override
  String toString() => json.encode(toJson());
}
