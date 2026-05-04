// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_volume_meters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputVolumeMeters _$InputVolumeMetersFromJson(Map<String, dynamic> json) =>
    InputVolumeMeters(
      inputs: (json['inputs'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$InputVolumeMetersToJson(InputVolumeMeters instance) =>
    <String, dynamic>{'inputs': instance.inputs};
