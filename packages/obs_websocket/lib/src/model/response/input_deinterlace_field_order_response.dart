import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/src/enum/obs_deinterlace_field_order.dart';

part 'input_deinterlace_field_order_response.g.dart';

@JsonSerializable()
class InputDeinterlaceFieldOrderResponse {
  @JsonKey(unknownEnumValue: ObsDeinterlaceFieldOrder.top)
  final ObsDeinterlaceFieldOrder deinterlaceFieldOrder;

  InputDeinterlaceFieldOrderResponse({required this.deinterlaceFieldOrder});

  factory InputDeinterlaceFieldOrderResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$InputDeinterlaceFieldOrderResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InputDeinterlaceFieldOrderResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
