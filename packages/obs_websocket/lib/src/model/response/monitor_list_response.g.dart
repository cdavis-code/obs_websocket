// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitorListResponse _$MonitorListResponseFromJson(Map<String, dynamic> json) =>
    MonitorListResponse(
      monitors: (json['monitors'] as List<dynamic>)
          .map((e) => Monitor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonitorListResponseToJson(
  MonitorListResponse instance,
) => <String, dynamic>{'monitors': instance.monitors};
