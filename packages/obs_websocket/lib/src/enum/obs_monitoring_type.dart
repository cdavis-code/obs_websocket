import 'package:json_annotation/json_annotation.dart';

/// Audio monitor type for an input
@JsonEnum()
enum ObsMonitoringType {
  @JsonValue('OBS_MONITORING_TYPE_NONE')
  none('OBS_MONITORING_TYPE_NONE'),
  @JsonValue('OBS_MONITORING_TYPE_MONITOR_ONLY')
  monitorOnly('OBS_MONITORING_TYPE_MONITOR_ONLY'),
  @JsonValue('OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT')
  monitorAndOutput('OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT');

  const ObsMonitoringType(this.code);

  final String code;

  /// Returns the enum value from its string code
  static ObsMonitoringType fromCode(String code) {
    return ObsMonitoringType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => ObsMonitoringType.none,
    );
  }

  @override
  String toString() => code;
}
