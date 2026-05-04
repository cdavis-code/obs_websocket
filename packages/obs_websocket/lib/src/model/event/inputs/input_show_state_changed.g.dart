// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_show_state_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputShowStateChanged _$InputShowStateChangedFromJson(
  Map<String, dynamic> json,
) => InputShowStateChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  videoShowing: json['videoShowing'] as bool,
);

Map<String, dynamic> _$InputShowStateChangedToJson(
  InputShowStateChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'videoShowing': instance.videoShowing,
};
