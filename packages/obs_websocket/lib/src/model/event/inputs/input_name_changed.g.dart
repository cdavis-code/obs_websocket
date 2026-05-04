// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_name_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputNameChanged _$InputNameChangedFromJson(Map<String, dynamic> json) =>
    InputNameChanged(
      inputUuid: json['inputUuid'] as String,
      oldInputName: json['oldInputName'] as String,
      inputName: json['inputName'] as String,
    );

Map<String, dynamic> _$InputNameChangedToJson(InputNameChanged instance) =>
    <String, dynamic>{
      'inputUuid': instance.inputUuid,
      'oldInputName': instance.oldInputName,
      'inputName': instance.inputName,
    };
