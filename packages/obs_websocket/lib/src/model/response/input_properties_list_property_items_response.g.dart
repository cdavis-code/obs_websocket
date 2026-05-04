// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_properties_list_property_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputPropertiesListPropertyItemsResponse
_$InputPropertiesListPropertyItemsResponseFromJson(Map<String, dynamic> json) =>
    InputPropertiesListPropertyItemsResponse(
      propertyItems: (json['propertyItems'] as List<dynamic>)
          .map((e) => PropertyItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InputPropertiesListPropertyItemsResponseToJson(
  InputPropertiesListPropertyItemsResponse instance,
) => <String, dynamic>{
  'propertyItems': instance.propertyItems.map((e) => e.toJson()).toList(),
};
