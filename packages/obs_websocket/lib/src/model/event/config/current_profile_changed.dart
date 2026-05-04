import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'current_profile_changed.g.dart';

/// The current profile has changed.
@JsonSerializable()
class CurrentProfileChanged implements BaseEvent {
  /// Name of the new profile
  final String profileName;

  CurrentProfileChanged({required this.profileName});

  factory CurrentProfileChanged.fromJson(Map<String, dynamic> json) =>
      _$CurrentProfileChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrentProfileChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
