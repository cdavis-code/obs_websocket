import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'screenshot_saved.g.dart';

/// A screenshot has been saved.
///
/// Note: Triggered for the screenshot feature available in Settings -> Hotkeys -> Screenshot Output ONLY. Applications using Get/SaveSourceScreenshot should implement a CustomEvent if this kind of inter-client communication is desired.
@JsonSerializable()
class ScreenshotSaved implements BaseEvent {
  /// Path of the saved image file
  final String savedScreenshotPath;

  ScreenshotSaved({required this.savedScreenshotPath});

  factory ScreenshotSaved.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotSavedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ScreenshotSavedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
