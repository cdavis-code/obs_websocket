// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneListResponse _$SceneListResponseFromJson(Map<String, dynamic> json) =>
    SceneListResponse(
      currentProgramSceneName: json['currentProgramSceneName'] as String,
      currentPreviewSceneName: json['currentPreviewSceneName'] as String?,
      scenes: (json['scenes'] as List<dynamic>)
          .map((e) => Scene.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SceneListResponseToJson(SceneListResponse instance) =>
    <String, dynamic>{
      'currentProgramSceneName': instance.currentProgramSceneName,
      'currentPreviewSceneName': instance.currentPreviewSceneName,
      'scenes': instance.scenes,
    };
