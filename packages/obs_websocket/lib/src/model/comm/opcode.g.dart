// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Opcode _$OpcodeFromJson(Map<String, dynamic> json) => Opcode(
  op: (json['op'] as num).toInt(),
  d: json['d'] as Map<String, dynamic>,
);

Map<String, dynamic> _$OpcodeToJson(Opcode instance) => <String, dynamic>{
  'op': instance.op,
  'd': instance.d,
};
