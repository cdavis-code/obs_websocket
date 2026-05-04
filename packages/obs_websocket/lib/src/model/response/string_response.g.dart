// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringResponse _$StringResponseFromJson(Map<String, dynamic> json) =>
    StringResponse(
      outputPath: json['outputPath'] as String?,
      currentProgramSceneName: json['currentProgramSceneName'] as String?,
      currentPreviewSceneName: json['currentPreviewSceneName'] as String?,
    );

Map<String, dynamic> _$StringResponseToJson(StringResponse instance) =>
    <String, dynamic>{
      'outputPath': instance.outputPath,
      'currentProgramSceneName': instance.currentProgramSceneName,
      'currentPreviewSceneName': instance.currentPreviewSceneName,
    };
