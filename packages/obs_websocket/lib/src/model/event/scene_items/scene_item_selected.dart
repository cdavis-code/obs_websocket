import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart' show SceneItem;

import '../base_event.dart';

part 'scene_item_selected.g.dart';

/// A scene item has been selected in the Ui.
@JsonSerializable()
class SceneItemSelected extends SceneItem implements BaseEvent {
  SceneItemSelected({required super.sceneName, required super.sceneItemId});

  factory SceneItemSelected.fromJson(Map<String, dynamic> json) =>
      _$SceneItemSelectedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SceneItemSelectedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
