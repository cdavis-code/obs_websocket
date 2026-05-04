// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_input_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInputResponse _$CreateInputResponseFromJson(Map<String, dynamic> json) =>
    CreateInputResponse(
      inputUuid: json['inputUuid'] as String,
      sceneItemId: (json['sceneItemId'] as num).toInt(),
    );

Map<String, dynamic> _$CreateInputResponseToJson(
  CreateInputResponse instance,
) => <String, dynamic>{
  'inputUuid': instance.inputUuid,
  'sceneItemId': instance.sceneItemId,
};
