enum ObsMediaState {
  none('OBS_MEDIA_STATE_NONE'),
  playing('OBS_MEDIA_STATE_PLAYING'),
  opening('OBS_MEDIA_STATE_OPENING'),
  buffering('OBS_MEDIA_STATE_BUFFERING'),
  paused('OBS_MEDIA_STATE_PAUSED'),
  stopped('OBS_MEDIA_STATE_STOPPED'),
  ended('OBS_MEDIA_STATE_ENDED'),
  error('OBS_MEDIA_STATE_ERROR');

  const ObsMediaState(this.code);

  final String code;

  /// Convert from JSON string message to enum value
  static ObsMediaState valuesByMessage(String code) {
    return ObsMediaState.values.firstWhere(
      (state) => state.code == code,
      orElse: () => ObsMediaState.none,
    );
  }

  /// Convert enum value to JSON string message
  static String toMessage(ObsMediaState state) {
    return state.code;
  }
}
