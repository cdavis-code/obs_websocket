import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'profile_list_response.g.dart';

@JsonSerializable()
class ProfileListResponse {
  final String currentProfileName;
  final List<String> profiles;

  ProfileListResponse({
    required this.currentProfileName,
    required this.profiles,
  });

  factory ProfileListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
