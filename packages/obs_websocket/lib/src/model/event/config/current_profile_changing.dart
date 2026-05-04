import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'current_profile_changing.g.dart';

/// The current profile has begun changing.
@JsonSerializable()
class CurrentProfileChanging implements BaseEvent {
  /// Name of the current profile
  final String profileName;

  CurrentProfileChanging({required this.profileName});

  factory CurrentProfileChanging.fromJson(Map<String, dynamic> json) =>
      _$CurrentProfileChangingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrentProfileChangingToJson(this);

  @override
  String toString() => json.encode(toJson());
}
