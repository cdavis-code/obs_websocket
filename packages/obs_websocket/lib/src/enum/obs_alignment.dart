/// OBS scene-item alignment values.
///
/// These bit-flag values match the OBS Studio source enum and are accepted
/// by the `alignment` and `boundsAlignment` fields of `SetSceneItemTransform`.
///
/// Combinations are produced by OR-ing horizontal and vertical bits, e.g.
/// `ObsAlignment.top.code | ObsAlignment.right.code` gives top-right.
/// The two convenience values [center] (5 = centerHorizontal | centerVertical
/// when written as left|top in OBS' coordinate system) and the named
/// `top*` / `bottom*` constants below mirror what OBS itself produces.
enum ObsAlignment {
  /// Center anchor. positionX/Y refer to the center of the source.
  center(0),

  /// Left edge alignment.
  left(1),

  /// Right edge alignment.
  right(2),

  /// Top edge alignment.
  top(4),

  /// Top-left corner. positionX/Y refer to the top-left of the source.
  topLeft(5),

  /// Top-right corner.
  topRight(6),

  /// Bottom edge alignment.
  bottom(8),

  /// Bottom-left corner.
  bottomLeft(9),

  /// Bottom-right corner.
  bottomRight(10);

  const ObsAlignment(this.code);

  /// Numeric bit-flag value sent to OBS.
  final int code;

  /// Returns the [ObsAlignment] for the given numeric [code], or `null`
  /// when [code] does not match a known constant.
  static ObsAlignment? fromCode(int code) {
    for (final value in ObsAlignment.values) {
      if (value.code == code) return value;
    }
    return null;
  }
}
