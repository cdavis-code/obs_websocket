import 'package:json_annotation/json_annotation.dart';

/// Deinterlace mode for an input
@JsonEnum()
enum ObsDeinterlaceMode {
  @JsonValue('OBS_DEINTERLACE_MODE_DISABLE')
  disable('OBS_DEINTERLACE_MODE_DISABLE'),
  @JsonValue('OBS_DEINTERLACE_MODE_DISCARD')
  discard('OBS_DEINTERLACE_MODE_DISCARD'),
  @JsonValue('OBS_DEINTERLACE_MODE_RETRO')
  retro('OBS_DEINTERLACE_MODE_RETRO'),
  @JsonValue('OBS_DEINTERLACE_MODE_BLEND')
  blend('OBS_DEINTERLACE_MODE_BLEND'),
  @JsonValue('OBS_DEINTERLACE_MODE_BLEND_2X')
  blend2x('OBS_DEINTERLACE_MODE_BLEND_2X'),
  @JsonValue('OBS_DEINTERLACE_MODE_LINEAR')
  linear('OBS_DEINTERLACE_MODE_LINEAR'),
  @JsonValue('OBS_DEINTERLACE_MODE_LINEAR_2X')
  linear2x('OBS_DEINTERLACE_MODE_LINEAR_2X'),
  @JsonValue('OBS_DEINTERLACE_MODE_YADIF')
  yadif('OBS_DEINTERLACE_MODE_YADIF'),
  @JsonValue('OBS_WEBSOCKET_DEINTERLACE_MODE_YADIF_2X')
  yadif2x('OBS_WEBSOCKET_DEINTERLACE_MODE_YADIF_2X');

  const ObsDeinterlaceMode(this.code);

  final String code;

  /// Returns the enum value from its string code
  static ObsDeinterlaceMode fromCode(String code) {
    return ObsDeinterlaceMode.values.firstWhere(
      (mode) => mode.code == code,
      orElse: () => ObsDeinterlaceMode.disable,
    );
  }

  @override
  String toString() => code;
}
