import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'source_screenshot.g.dart';

@JsonSerializable()
class SourceScreenshot {
  final String sourceName;
  final String imageFormat;
  final String? imageFilePath;
  final int? imageWidth;
  final int? imageHeight;
  final int? imageCompressionQuality;

  SourceScreenshot({
    required this.sourceName,
    required this.imageFormat,
    this.imageFilePath,
    this.imageWidth,
    this.imageHeight,
    this.imageCompressionQuality,
  });

  factory SourceScreenshot.fromJson(Map<String, dynamic> json) =>
      _$SourceScreenshotFromJson(json);

  Map<String, dynamic> toJson() => _$SourceScreenshotToJson(this);

  @override
  String toString() => json.encode(toJson());
}
