import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'media_input_action_triggered.g.dart';

/// An action has been performed on an input.
@JsonSerializable()
class MediaInputActionTriggered implements BaseEvent {
  /// Name of the input
  final String inputName;

  /// UUID of the input
  final String? inputUuid;

  /// Action performed on the input. See `ObsMediaInputAction` enum
  final String mediaAction;

  MediaInputActionTriggered({
    required this.inputName,
    this.inputUuid,
    required this.mediaAction,
  });

  factory MediaInputActionTriggered.fromJson(Map<String, dynamic> json) =>
      _$MediaInputActionTriggeredFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaInputActionTriggeredToJson(this);

  @override
  String toString() => json.encode(toJson());
}
