import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'input_properties_list_property_items_response.g.dart';

/// Response for GetInputPropertiesListPropertyItems request
@JsonSerializable(explicitToJson: true)
class InputPropertiesListPropertyItemsResponse {
  /// List of property items for a list property
  final List<PropertyItem> propertyItems;

  InputPropertiesListPropertyItemsResponse({required this.propertyItems});

  factory InputPropertiesListPropertyItemsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$InputPropertiesListPropertyItemsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InputPropertiesListPropertyItemsResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
