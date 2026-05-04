enum ObsMonitoringType {
  none('OBS_MONITORING_TYPE_NONE'),
  play('OBS_MONITORING_TYPE_MONITOR_ONLY'),
  pause('OBS_MONITORING_TYPE_MONITOR_AND_OUTPUT');

  const ObsMonitoringType(this.code);

  final String code;
}
