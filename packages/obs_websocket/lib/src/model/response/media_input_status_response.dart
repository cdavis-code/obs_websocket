import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'media_input_status_response.g.dart';

@JsonSerializable()
class MediaInputStatusResponse {
  @JsonKey(
    fromJson: ObsMediaState.valuesByMessage,
    toJson: ObsMediaState.toMessage,
  )
  /// State of the media input
  final ObsMediaState mediaState;

  /// Total duration of the playing media in milliseconds. null if not playing
  final int? mediaDuration;

  /// 	Position of the cursor in milliseconds. null if not playing
  final int? mediaCursor;

  MediaInputStatusResponse({
    required this.mediaState,
    this.mediaDuration,
    this.mediaCursor,
  });

  factory MediaInputStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$MediaInputStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MediaInputStatusResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
