// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_active_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceActiveResponse _$SourceActiveResponseFromJson(
  Map<String, dynamic> json,
) => SourceActiveResponse(
  videoActive: json['videoActive'] as bool,
  videoShowing: json['videoShowing'] as bool,
);

Map<String, dynamic> _$SourceActiveResponseToJson(
  SourceActiveResponse instance,
) => <String, dynamic>{
  'videoActive': instance.videoActive,
  'videoShowing': instance.videoShowing,
};
