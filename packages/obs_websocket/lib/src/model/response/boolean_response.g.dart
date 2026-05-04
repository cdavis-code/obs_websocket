// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooleanResponse _$BooleanResponseFromJson(Map<String, dynamic> json) =>
    BooleanResponse(
      outputActive: json['outputActive'] as bool?,
      sceneItemEnabled: json['sceneItemEnabled'] as bool?,
      studioModeEnabled: json['studioModeEnabled'] as bool?,
      inputMuted: json['inputMuted'] as bool?,
      sceneItemLocked: json['sceneItemLocked'] as bool?,
    );

Map<String, dynamic> _$BooleanResponseToJson(BooleanResponse instance) =>
    <String, dynamic>{
      'outputActive': instance.outputActive,
      'sceneItemEnabled': instance.sceneItemEnabled,
      'studioModeEnabled': instance.studioModeEnabled,
      'inputMuted': instance.inputMuted,
      'sceneItemLocked': instance.sceneItemLocked,
    };
