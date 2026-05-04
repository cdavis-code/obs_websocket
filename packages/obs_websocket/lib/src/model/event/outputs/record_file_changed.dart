import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_event.dart';

part 'record_file_changed.g.dart';

/// The record output has started writing to a new file.
///
/// For example, file splitting or manual chapter creation.
///
/// Added in v5.5.0
@JsonSerializable()
class RecordFileChanged implements BaseEvent {
  /// File name that the output has begun writing to
  final String newOutputPath;

  RecordFileChanged({required this.newOutputPath});

  factory RecordFileChanged.fromJson(Map<String, dynamic> json) =>
      _$RecordFileChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RecordFileChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
