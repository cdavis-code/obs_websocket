// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_modifiers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyModifiers _$KeyModifiersFromJson(Map<String, dynamic> json) => KeyModifiers(
  shift: json['shift'] as bool?,
  control: json['control'] as bool?,
  alt: json['alt'] as bool?,
  command: json['command'] as bool?,
);

Map<String, dynamic> _$KeyModifiersToJson(KeyModifiers instance) =>
    <String, dynamic>{
      'shift': instance.shift,
      'control': instance.control,
      'alt': instance.alt,
      'command': instance.command,
    };
