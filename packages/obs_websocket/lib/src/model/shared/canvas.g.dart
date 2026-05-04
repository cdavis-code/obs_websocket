// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Canvas _$CanvasFromJson(Map<String, dynamic> json) => Canvas(
  canvasFlags: CanvasFlags.fromJson(
    json['canvasFlags'] as Map<String, dynamic>,
  ),
  canvasName: json['canvasName'] as String,
  canvasUuid: json['canvasUuid'] as String,
  canvasVideoSettings: CanvasVideoSettings.fromJson(
    json['canvasVideoSettings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CanvasToJson(Canvas instance) => <String, dynamic>{
  'canvasFlags': instance.canvasFlags,
  'canvasName': instance.canvasName,
  'canvasUuid': instance.canvasUuid,
  'canvasVideoSettings': instance.canvasVideoSettings,
};
