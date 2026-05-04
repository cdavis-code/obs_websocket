import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'transform.g.dart';

@JsonSerializable()
class Transform {
  final int alignment;
  final int boundsAlignment;
  final double boundsHeight;
  final String boundsType;
  final double boundsWidth;
  final int cropBottom;
  final int cropLeft;
  final int cropRight;
  final int cropTop;
  final double height;
  final double positionX;
  final double positionY;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final double sourceHeight;
  final double sourceWidth;
  final double width;

  Transform({
    required this.alignment,
    required this.boundsAlignment,
    required this.boundsHeight,
    required this.boundsType,
    required this.boundsWidth,
    required this.cropBottom,
    required this.cropLeft,
    required this.cropRight,
    required this.cropTop,
    required this.height,
    required this.positionX,
    required this.positionY,
    required this.rotation,
    required this.scaleX,
    required this.scaleY,
    required this.sourceHeight,
    required this.sourceWidth,
    required this.width,
  });

  factory Transform.fromJson(Map<String, dynamic> json) =>
      _$TransformFromJson(json);

  Map<String, dynamic> toJson() => _$TransformToJson(this);

  @override
  String toString() => json.encode(toJson());
}
