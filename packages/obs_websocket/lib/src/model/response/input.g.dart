// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Input _$InputFromJson(Map<String, dynamic> json) => Input(
  inputKind: json['inputKind'] as String,
  inputName: json['inputName'] as String,
  unversionedInputKind: json['unversionedInputKind'] as String,
);

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
  'inputKind': instance.inputKind,
  'inputName': instance.inputName,
  'unversionedInputKind': instance.unversionedInputKind,
};
