/// Animation helpers used by `obs_scene_items_animate_transform`.
///
/// Copied from `packages/obs_mcp/lib/src/animation_helpers.dart` — this file
/// is pure Dart with no dart:io dependencies.
library;

import 'dart:math' as math;

import 'package:obs_websocket/obs_websocket.dart';

/// Returns the easing function for [name].
double Function(double) resolveEasing(String? name) {
  switch (name) {
    case null:
    case 'linear':
      return (t) => t;
    case 'easeIn':
      return (t) => t * t;
    case 'easeOut':
      return (t) => 1 - (1 - t) * (1 - t);
    case 'easeInOut':
      return (t) => t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;
    case 'easeOutBounce':
      return (t) {
        const n1 = 7.5625;
        const d1 = 2.75;
        if (t < 1 / d1) {
          return n1 * t * t;
        } else if (t < 2 / d1) {
          final v = t - 1.5 / d1;
          return n1 * v * v + 0.75;
        } else if (t < 2.5 / d1) {
          final v = t - 2.25 / d1;
          return n1 * v * v + 0.9375;
        } else {
          final v = t - 2.625 / d1;
          return n1 * v * v + 0.984375;
        }
      };
    default:
      throw ArgumentError(
        'Unknown easing "$name". Use linear|easeIn|easeOut|easeInOut|easeOutBounce.',
      );
  }
}

/// Linear interpolation between [a] and [b] at parameter [t] (0..1).
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  if (a == null) return b;
  if (b == null) return a;
  return a + (b - a) * t;
}

/// Integer companion to [lerpDouble].
int? lerpInt(int? a, int? b, double t) {
  final lerped = lerpDouble(a?.toDouble(), b?.toDouble(), t);
  return lerped?.round();
}

/// Builds an intermediate [SceneItemTransform] between [from] and [to].
SceneItemTransform interpolateTransform(
  SceneItemTransform from,
  SceneItemTransform to,
  double t,
) {
  return SceneItemTransform(
    positionX: lerpDouble(from.positionX, to.positionX, t),
    positionY: lerpDouble(from.positionY, to.positionY, t),
    scaleX: lerpDouble(from.scaleX, to.scaleX, t),
    scaleY: lerpDouble(from.scaleY, to.scaleY, t),
    rotation: lerpDouble(from.rotation, to.rotation, t),
    cropLeft: lerpInt(from.cropLeft, to.cropLeft, t),
    cropTop: lerpInt(from.cropTop, to.cropTop, t),
    cropRight: lerpInt(from.cropRight, to.cropRight, t),
    cropBottom: lerpInt(from.cropBottom, to.cropBottom, t),
    alignment: to.alignment ?? from.alignment,
    boundsType: to.boundsType ?? from.boundsType,
    boundsAlignment: to.boundsAlignment ?? from.boundsAlignment,
    boundsWidth: lerpDouble(from.boundsWidth, to.boundsWidth, t),
    boundsHeight: lerpDouble(from.boundsHeight, to.boundsHeight, t),
  );
}

/// Resolves an event-subscription mask from either a raw [mask] or a list
/// of subscription [names].
int parseEventSubscription(int? mask, List<String>? names) {
  if (mask != null && names != null && names.isNotEmpty) {
    throw ArgumentError('Provide either mask or subscriptions, not both.');
  }
  if (mask != null) return mask;
  if (names == null || names.isEmpty) {
    return EventSubscription.all.code;
  }
  var combined = 0;
  for (final name in names) {
    final match = EventSubscription.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError(
        'Unknown EventSubscription "$name". Valid values: '
        '${EventSubscription.values.map((e) => e.name).join(', ')}',
      ),
    );
    combined |= match.code;
  }
  return combined;
}
