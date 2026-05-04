// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_deinterlace_mode_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputDeinterlaceModeResponse _$InputDeinterlaceModeResponseFromJson(
  Map<String, dynamic> json,
) => InputDeinterlaceModeResponse(
  deinterlaceMode: $enumDecode(
    _$ObsDeinterlaceModeEnumMap,
    json['deinterlaceMode'],
    unknownValue: ObsDeinterlaceMode.disable,
  ),
);

Map<String, dynamic> _$InputDeinterlaceModeResponseToJson(
  InputDeinterlaceModeResponse instance,
) => <String, dynamic>{
  'deinterlaceMode': _$ObsDeinterlaceModeEnumMap[instance.deinterlaceMode]!,
};

const _$ObsDeinterlaceModeEnumMap = {
  ObsDeinterlaceMode.disable: 'OBS_DEINTERLACE_MODE_DISABLE',
  ObsDeinterlaceMode.discard: 'OBS_DEINTERLACE_MODE_DISCARD',
  ObsDeinterlaceMode.retro: 'OBS_DEINTERLACE_MODE_RETRO',
  ObsDeinterlaceMode.blend: 'OBS_DEINTERLACE_MODE_BLEND',
  ObsDeinterlaceMode.blend2x: 'OBS_DEINTERLACE_MODE_BLEND_2X',
  ObsDeinterlaceMode.linear: 'OBS_DEINTERLACE_MODE_LINEAR',
  ObsDeinterlaceMode.linear2x: 'OBS_DEINTERLACE_MODE_LINEAR_2X',
  ObsDeinterlaceMode.yadif: 'OBS_DEINTERLACE_MODE_YADIF',
  ObsDeinterlaceMode.yadif2x: 'OBS_WEBSOCKET_DEINTERLACE_MODE_YADIF_2X',
};
