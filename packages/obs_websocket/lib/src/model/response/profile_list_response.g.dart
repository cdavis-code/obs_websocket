// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileListResponse _$ProfileListResponseFromJson(Map<String, dynamic> json) =>
    ProfileListResponse(
      currentProfileName: json['currentProfileName'] as String,
      profiles: (json['profiles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProfileListResponseToJson(
  ProfileListResponse instance,
) => <String, dynamic>{
  'currentProfileName': instance.currentProfileName,
  'profiles': instance.profiles,
};
