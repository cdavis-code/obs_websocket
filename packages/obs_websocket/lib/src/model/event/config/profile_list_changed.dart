import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'profile_list_changed.g.dart';

/// The scene collection list has changed.
@JsonSerializable()
class ProfileListChanged implements BaseEvent {
  /// Updated list of profiles
  final List<String> profiles;

  ProfileListChanged({required this.profiles});

  factory ProfileListChanged.fromJson(Map<String, dynamic> json) =>
      _$ProfileListChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileListChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
