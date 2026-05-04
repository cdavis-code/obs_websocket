import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show Transform;

part 'scene_item_detail.g.dart';

@JsonSerializable()
class SceneItemDetail {
  final String? inputKind;
  final bool? isGroup;
  final String sceneItemBlendMode;
  final bool sceneItemEnabled;
  final int sceneItemId;
  final int sceneItemIndex;
  final bool sceneItemLocked;
  final Transform sceneItemTransform;
  final String sourceName;
  final String sourceType;

  SceneItemDetail({
    this.inputKind,
    required this.isGroup,
    required this.sceneItemBlendMode,
    required this.sceneItemEnabled,
    required this.sceneItemId,
    required this.sceneItemIndex,
    required this.sceneItemLocked,
    required this.sceneItemTransform,
    required this.sourceName,
    required this.sourceType,
  });

  factory SceneItemDetail.fromJson(Map<String, dynamic> json) =>
      _$SceneItemDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SceneItemDetailToJson(this);

  @override
  String toString() => json.encode(toJson());
}
