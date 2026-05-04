// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_flags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasFlags _$CanvasFlagsFromJson(Map<String, dynamic> json) => CanvasFlags(
  activate: json['ACTIVATE'] as bool,
  ephemeral: json['EPHEMERAL'] as bool,
  main: json['MAIN'] as bool,
  mixAudio: json['MIX_AUDIO'] as bool,
  sceneRef: json['SCENE_REF'] as bool,
);

Map<String, dynamic> _$CanvasFlagsToJson(CanvasFlags instance) =>
    <String, dynamic>{
      'ACTIVATE': instance.activate,
      'EPHEMERAL': instance.ephemeral,
      'MAIN': instance.main,
      'MIX_AUDIO': instance.mixAudio,
      'SCENE_REF': instance.sceneRef,
    };
