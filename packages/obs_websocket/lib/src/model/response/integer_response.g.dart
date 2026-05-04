// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntegerResponse _$IntegerResponseFromJson(Map<String, dynamic> json) =>
    IntegerResponse(
      sceneItemId: (json['sceneItemId'] as num?)?.toInt(),
      sceneItemIndex: (json['sceneItemIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IntegerResponseToJson(IntegerResponse instance) =>
    <String, dynamic>{
      'sceneItemId': instance.sceneItemId,
      'sceneItemIndex': instance.sceneItemIndex,
    };
