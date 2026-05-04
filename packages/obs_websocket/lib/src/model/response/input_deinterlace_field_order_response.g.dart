// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_deinterlace_field_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputDeinterlaceFieldOrderResponse _$InputDeinterlaceFieldOrderResponseFromJson(
  Map<String, dynamic> json,
) => InputDeinterlaceFieldOrderResponse(
  deinterlaceFieldOrder: $enumDecode(
    _$ObsDeinterlaceFieldOrderEnumMap,
    json['deinterlaceFieldOrder'],
    unknownValue: ObsDeinterlaceFieldOrder.top,
  ),
);

Map<String, dynamic> _$InputDeinterlaceFieldOrderResponseToJson(
  InputDeinterlaceFieldOrderResponse instance,
) => <String, dynamic>{
  'deinterlaceFieldOrder':
      _$ObsDeinterlaceFieldOrderEnumMap[instance.deinterlaceFieldOrder]!,
};

const _$ObsDeinterlaceFieldOrderEnumMap = {
  ObsDeinterlaceFieldOrder.top: 'OBS_DEINTERLACE_FIELD_ORDER_TOP',
  ObsDeinterlaceFieldOrder.bottom: 'OBS_DEINTERLACE_FIELD_ORDER_BOTTOM',
};
