// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringListResponse _$StringListResponseFromJson(Map<String, dynamic> json) =>
    StringListResponse(
      hotkeys: (json['hotkeys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      inputKinds: (json['inputKinds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StringListResponseToJson(StringListResponse instance) =>
    <String, dynamic>{
      'hotkeys': instance.hotkeys,
      'groups': instance.groups,
      'inputKinds': instance.inputKinds,
    };
