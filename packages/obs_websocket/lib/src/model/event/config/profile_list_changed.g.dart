// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_list_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileListChanged _$ProfileListChangedFromJson(Map<String, dynamic> json) =>
    ProfileListChanged(
      profiles: (json['profiles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProfileListChangedToJson(ProfileListChanged instance) =>
    <String, dynamic>{'profiles': instance.profiles};
