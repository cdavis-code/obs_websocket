// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_input_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInputStatusResponse _$MediaInputStatusResponseFromJson(
  Map<String, dynamic> json,
) => MediaInputStatusResponse(
  mediaState: ObsMediaState.valuesByMessage(json['mediaState'] as String),
  mediaDuration: (json['mediaDuration'] as num?)?.toInt(),
  mediaCursor: (json['mediaCursor'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaInputStatusResponseToJson(
  MediaInputStatusResponse instance,
) => <String, dynamic>{
  'mediaState': ObsMediaState.toMessage(instance.mediaState),
  'mediaDuration': instance.mediaDuration,
  'mediaCursor': instance.mediaCursor,
};
