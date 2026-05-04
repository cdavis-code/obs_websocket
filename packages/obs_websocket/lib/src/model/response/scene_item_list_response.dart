import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show SceneItemDetail;

part 'scene_item_list_response.g.dart';

@JsonSerializable()
class SceneItemListResponse {
  final List<SceneItemDetail> sceneItems;

  SceneItemListResponse({required this.sceneItems});

  factory SceneItemListResponse.fromJson(Map<String, dynamic> json) =>
      _$SceneItemListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SceneItemListResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
