import 'dart:convert';

import 'package:obs_websocket/src/error/obs_exception.dart';

/// Strongly-typed, partial-update friendly model of an OBS scene-item
/// transform.
///
/// Unlike the legacy fully-required [Transform] response model, every field
/// here is nullable so callers can construct sparse transforms for use with
/// `SetSceneItemTransform`. Only fields that are non-null are forwarded to
/// OBS.
///
/// The class also exposes:
/// - [SceneItemTransform.fromJson] that round-trips OBS responses (numbers
///   are coerced to `double`/`int`).
/// - [toJson] which omits null fields.
/// - [copyWith] for layered updates.
/// - [validate] which throws [ObsArgumentException] for unknown JSON keys
///   when constructing from a raw map via [SceneItemTransform.fromJsonStrict].
class SceneItemTransform {
  /// Recognised JSON keys. Used by [SceneItemTransform.fromJsonStrict] to
  /// reject typos client-side instead of letting OBS silently ignore them.
  static const Set<String> knownKeys = <String>{
    'positionX',
    'positionY',
    'scaleX',
    'scaleY',
    'rotation',
    'cropLeft',
    'cropTop',
    'cropRight',
    'cropBottom',
    'alignment',
    'boundsAlignment',
    'boundsType',
    'boundsWidth',
    'boundsHeight',
    'sourceWidth',
    'sourceHeight',
    'width',
    'height',
  };

  /// Horizontal position in pixels.
  final double? positionX;

  /// Vertical position in pixels.
  final double? positionY;

  /// Horizontal scale factor (1.0 = 100%).
  final double? scaleX;

  /// Vertical scale factor (1.0 = 100%).
  final double? scaleY;

  /// Rotation in degrees clockwise.
  final double? rotation;

  /// Pixels cropped from the left edge.
  final int? cropLeft;

  /// Pixels cropped from the top edge.
  final int? cropTop;

  /// Pixels cropped from the right edge.
  final int? cropRight;

  /// Pixels cropped from the bottom edge.
  final int? cropBottom;

  /// Alignment bit-flag (see `ObsAlignment`).
  final int? alignment;

  /// Alignment of the source within its bounds (see `ObsAlignment`).
  final int? boundsAlignment;

  /// Bounds type protocol string (see `ObsBoundsType`).
  final String? boundsType;

  /// Width of the bounding box in pixels.
  final double? boundsWidth;

  /// Height of the bounding box in pixels.
  final double? boundsHeight;

  /// Read-only native width of the source in pixels (returned by OBS).
  final double? sourceWidth;

  /// Read-only native height of the source in pixels (returned by OBS).
  final double? sourceHeight;

  /// Read-only on-canvas width after scaling/bounds (returned by OBS).
  final double? width;

  /// Read-only on-canvas height after scaling/bounds (returned by OBS).
  final double? height;

  const SceneItemTransform({
    this.positionX,
    this.positionY,
    this.scaleX,
    this.scaleY,
    this.rotation,
    this.cropLeft,
    this.cropTop,
    this.cropRight,
    this.cropBottom,
    this.alignment,
    this.boundsAlignment,
    this.boundsType,
    this.boundsWidth,
    this.boundsHeight,
    this.sourceWidth,
    this.sourceHeight,
    this.width,
    this.height,
  });

  /// Lenient parser. Unknown keys are ignored so OBS can add fields without
  /// breaking older clients.
  factory SceneItemTransform.fromJson(Map<String, dynamic> json) {
    return SceneItemTransform(
      positionX: _toDouble(json['positionX']),
      positionY: _toDouble(json['positionY']),
      scaleX: _toDouble(json['scaleX']),
      scaleY: _toDouble(json['scaleY']),
      rotation: _toDouble(json['rotation']),
      cropLeft: _toInt(json['cropLeft']),
      cropTop: _toInt(json['cropTop']),
      cropRight: _toInt(json['cropRight']),
      cropBottom: _toInt(json['cropBottom']),
      alignment: _toInt(json['alignment']),
      boundsAlignment: _toInt(json['boundsAlignment']),
      boundsType: json['boundsType'] as String?,
      boundsWidth: _toDouble(json['boundsWidth']),
      boundsHeight: _toDouble(json['boundsHeight']),
      sourceWidth: _toDouble(json['sourceWidth']),
      sourceHeight: _toDouble(json['sourceHeight']),
      width: _toDouble(json['width']),
      height: _toDouble(json['height']),
    );
  }

  /// Strict parser that throws [ObsArgumentException] for unknown keys.
  ///
  /// Use this on client-supplied maps so typos like `position_x` surface
  /// immediately instead of being silently dropped by OBS.
  factory SceneItemTransform.fromJsonStrict(Map<String, dynamic> json) {
    validate(json);
    return SceneItemTransform.fromJson(json);
  }

  /// Throws [ObsArgumentException] when [json] contains keys outside of
  /// [knownKeys]. Returns silently when every key is recognised.
  static void validate(Map<String, dynamic> json) {
    final unknown = json.keys.where((k) => !knownKeys.contains(k)).toList();
    if (unknown.isNotEmpty) {
      throw ObsArgumentException(
        'Unknown SceneItemTransform key(s): ${unknown.join(', ')}. '
        'Allowed: ${knownKeys.join(', ')}.',
      );
    }
  }

  /// Returns a JSON map containing only the non-null fields. Suitable for
  /// `SetSceneItemTransform.sceneItemTransform`.
  Map<String, dynamic> toJson() {
    final out = <String, dynamic>{};
    if (positionX != null) out['positionX'] = positionX;
    if (positionY != null) out['positionY'] = positionY;
    if (scaleX != null) out['scaleX'] = scaleX;
    if (scaleY != null) out['scaleY'] = scaleY;
    if (rotation != null) out['rotation'] = rotation;
    if (cropLeft != null) out['cropLeft'] = cropLeft;
    if (cropTop != null) out['cropTop'] = cropTop;
    if (cropRight != null) out['cropRight'] = cropRight;
    if (cropBottom != null) out['cropBottom'] = cropBottom;
    if (alignment != null) out['alignment'] = alignment;
    if (boundsAlignment != null) out['boundsAlignment'] = boundsAlignment;
    if (boundsType != null) out['boundsType'] = boundsType;
    if (boundsWidth != null) out['boundsWidth'] = boundsWidth;
    if (boundsHeight != null) out['boundsHeight'] = boundsHeight;
    if (sourceWidth != null) out['sourceWidth'] = sourceWidth;
    if (sourceHeight != null) out['sourceHeight'] = sourceHeight;
    if (width != null) out['width'] = width;
    if (height != null) out['height'] = height;
    return out;
  }

  /// Returns a new transform with [other]'s non-null fields layered on top.
  SceneItemTransform merge(SceneItemTransform other) {
    return SceneItemTransform(
      positionX: other.positionX ?? positionX,
      positionY: other.positionY ?? positionY,
      scaleX: other.scaleX ?? scaleX,
      scaleY: other.scaleY ?? scaleY,
      rotation: other.rotation ?? rotation,
      cropLeft: other.cropLeft ?? cropLeft,
      cropTop: other.cropTop ?? cropTop,
      cropRight: other.cropRight ?? cropRight,
      cropBottom: other.cropBottom ?? cropBottom,
      alignment: other.alignment ?? alignment,
      boundsAlignment: other.boundsAlignment ?? boundsAlignment,
      boundsType: other.boundsType ?? boundsType,
      boundsWidth: other.boundsWidth ?? boundsWidth,
      boundsHeight: other.boundsHeight ?? boundsHeight,
      sourceWidth: other.sourceWidth ?? sourceWidth,
      sourceHeight: other.sourceHeight ?? sourceHeight,
      width: other.width ?? width,
      height: other.height ?? height,
    );
  }

  /// Returns a copy with the supplied fields replaced.
  SceneItemTransform copyWith({
    double? positionX,
    double? positionY,
    double? scaleX,
    double? scaleY,
    double? rotation,
    int? cropLeft,
    int? cropTop,
    int? cropRight,
    int? cropBottom,
    int? alignment,
    int? boundsAlignment,
    String? boundsType,
    double? boundsWidth,
    double? boundsHeight,
    double? sourceWidth,
    double? sourceHeight,
    double? width,
    double? height,
  }) {
    return SceneItemTransform(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      rotation: rotation ?? this.rotation,
      cropLeft: cropLeft ?? this.cropLeft,
      cropTop: cropTop ?? this.cropTop,
      cropRight: cropRight ?? this.cropRight,
      cropBottom: cropBottom ?? this.cropBottom,
      alignment: alignment ?? this.alignment,
      boundsAlignment: boundsAlignment ?? this.boundsAlignment,
      boundsType: boundsType ?? this.boundsType,
      boundsWidth: boundsWidth ?? this.boundsWidth,
      boundsHeight: boundsHeight ?? this.boundsHeight,
      sourceWidth: sourceWidth ?? this.sourceWidth,
      sourceHeight: sourceHeight ?? this.sourceHeight,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  String toString() => json.encode(toJson());

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _toInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
