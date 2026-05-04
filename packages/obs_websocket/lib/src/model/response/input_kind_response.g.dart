// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_kind_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputKindResponse _$InputKindResponseFromJson(Map<String, dynamic> json) =>
    InputKindResponse(
      inputs: (json['inputs'] as List<dynamic>)
          .map((e) => Input.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InputKindResponseToJson(InputKindResponse instance) =>
    <String, dynamic>{'inputs': instance.inputs};
