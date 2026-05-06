/// Bounds type values for an OBS scene item.
///
/// Sent as the `boundsType` field of `SetSceneItemTransform`. The string
/// values match exactly what the OBS WebSocket v5 protocol accepts.
enum ObsBoundsType {
  /// No bounding box. The source is rendered at its native dimensions
  /// scaled by [scaleX]/[scaleY].
  none('OBS_BOUNDS_NONE'),

  /// Stretch the source to fully fill the bounds, ignoring aspect ratio.
  stretch('OBS_BOUNDS_STRETCH'),

  /// Scale the source to fit fully within the bounds, preserving aspect.
  scaleInner('OBS_BOUNDS_SCALE_INNER'),

  /// Scale the source so it covers the bounds entirely, preserving aspect
  /// (may crop).
  scaleOuter('OBS_BOUNDS_SCALE_OUTER'),

  /// Scale to fit width while preserving aspect ratio.
  scaleToWidth('OBS_BOUNDS_SCALE_TO_WIDTH'),

  /// Scale to fit height while preserving aspect ratio.
  scaleToHeight('OBS_BOUNDS_SCALE_TO_HEIGHT'),

  /// Use the maximum size that fits within the bounds without scaling up.
  maxOnly('OBS_BOUNDS_MAX_ONLY');

  const ObsBoundsType(this.code);

  /// Protocol string sent to OBS, e.g. `OBS_BOUNDS_STRETCH`.
  final String code;

  /// Returns the [ObsBoundsType] matching [code], or `null` when [code]
  /// does not match a known constant.
  static ObsBoundsType? fromCode(String code) {
    for (final value in ObsBoundsType.values) {
      if (value.code == code) return value;
    }
    return null;
  }

  @override
  String toString() => code;
}
