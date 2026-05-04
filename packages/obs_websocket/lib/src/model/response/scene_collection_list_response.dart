import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'scene_collection_list_response.g.dart';

@JsonSerializable()
class SceneCollectionListResponse {
  final String currentSceneCollectionName;
  final List<String> sceneCollections;

  SceneCollectionListResponse({
    required this.currentSceneCollectionName,
    required this.sceneCollections,
  });

  factory SceneCollectionListResponse.fromJson(Map<String, dynamic> json) =>
      _$SceneCollectionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SceneCollectionListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
