import 'package:json_annotation/json_annotation.dart';

/// Deinterlace field order for an input
@JsonEnum()
enum ObsDeinterlaceFieldOrder {
  @JsonValue('OBS_DEINTERLACE_FIELD_ORDER_TOP')
  top('OBS_DEINTERLACE_FIELD_ORDER_TOP'),
  @JsonValue('OBS_DEINTERLACE_FIELD_ORDER_BOTTOM')
  bottom('OBS_DEINTERLACE_FIELD_ORDER_BOTTOM');

  const ObsDeinterlaceFieldOrder(this.code);

  final String code;

  /// Returns the enum value from its string code
  static ObsDeinterlaceFieldOrder fromCode(String code) {
    return ObsDeinterlaceFieldOrder.values.firstWhere(
      (order) => order.code == code,
      orElse: () => ObsDeinterlaceFieldOrder.top,
    );
  }

  @override
  String toString() => code;
}
