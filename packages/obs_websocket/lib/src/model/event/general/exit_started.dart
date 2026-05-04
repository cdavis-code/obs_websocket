import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'exit_started.g.dart';

@JsonSerializable()
class ExitStarted implements BaseEvent {
  ExitStarted();

  factory ExitStarted.fromJson(Map<String, dynamic> json) =>
      _$ExitStartedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExitStartedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
