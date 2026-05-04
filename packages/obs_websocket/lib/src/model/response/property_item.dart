import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'property_item.g.dart';

/// A single property item in a list
@JsonSerializable()
class PropertyItem {
  /// Unique item value
  final String itemValue;

  /// Human-readable item text
  final String itemText;

  /// Whether the item is enabled
  final bool itemEnabled;

  PropertyItem({
    required this.itemValue,
    required this.itemText,
    required this.itemEnabled,
  });

  factory PropertyItem.fromJson(Map<String, dynamic> json) =>
      _$PropertyItemFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyItemToJson(this);

  @override
  String toString() => json.encode(toJson());
}
