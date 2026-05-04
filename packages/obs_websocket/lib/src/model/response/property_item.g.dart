// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyItem _$PropertyItemFromJson(Map<String, dynamic> json) => PropertyItem(
  itemValue: json['itemValue'] as String,
  itemText: json['itemText'] as String,
  itemEnabled: json['itemEnabled'] as bool,
);

Map<String, dynamic> _$PropertyItemToJson(PropertyItem instance) =>
    <String, dynamic>{
      'itemValue': instance.itemValue,
      'itemText': instance.itemText,
      'itemEnabled': instance.itemEnabled,
    };
