import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'record_directory_response.g.dart';

@JsonSerializable()
class RecordDirectoryResponse {
  /// Output directory
  final String recordDirectory;

  RecordDirectoryResponse({required this.recordDirectory});

  factory RecordDirectoryResponse.fromJson(Map<String, dynamic> json) =>
      _$RecordDirectoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecordDirectoryResponseToJson(this);

  @override
  String toString() => json.encode(toJson());
}
