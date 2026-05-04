// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_audio_balance_changed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputAudioBalanceChanged _$InputAudioBalanceChangedFromJson(
  Map<String, dynamic> json,
) => InputAudioBalanceChanged(
  inputName: json['inputName'] as String,
  inputUuid: json['inputUuid'] as String,
  inputAudioBalance: (json['inputAudioBalance'] as num).toDouble(),
);

Map<String, dynamic> _$InputAudioBalanceChangedToJson(
  InputAudioBalanceChanged instance,
) => <String, dynamic>{
  'inputName': instance.inputName,
  'inputUuid': instance.inputUuid,
  'inputAudioBalance': instance.inputAudioBalance,
};
