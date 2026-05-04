// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_parameter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileParameterResponse _$ProfileParameterResponseFromJson(
  Map<String, dynamic> json,
) => ProfileParameterResponse(
  parameterValue: json['parameterValue'] as String,
  defaultParameterValue: json['defaultParameterValue'] as String,
);

Map<String, dynamic> _$ProfileParameterResponseToJson(
  ProfileParameterResponse instance,
) => <String, dynamic>{
  'parameterValue': instance.parameterValue,
  'defaultParameterValue': instance.defaultParameterValue,
};
