// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasListResponse _$CanvasListResponseFromJson(Map<String, dynamic> json) =>
    CanvasListResponse(
      currentCanvasName: json['currentCanvasName'] as String,
      canvases: (json['canvases'] as List<dynamic>)
          .map((e) => Canvas.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CanvasListResponseToJson(CanvasListResponse instance) =>
    <String, dynamic>{
      'currentCanvasName': instance.currentCanvasName,
      'canvases': instance.canvases,
    };
