/// Typed exception hierarchy for all `obs_websocket` runtime errors.
///
/// Prefer throwing a specific subtype over a bare [Exception] so callers
/// can react to auth vs network vs request failures distinctly. Every
/// subtype carries an optional [cause] and [stackTrace] so upper layers
/// can re-report without losing the original context.
library;

/// Base class for all obs_websocket errors.
sealed class ObsException implements Exception {
  /// Human-readable description of the error.
  final String message;

  /// Original error that triggered this exception, if any.
  final Object? cause;

  /// Stack trace captured at the throw site, when available.
  final StackTrace? stackTrace;

  const ObsException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() {
    final buf = StringBuffer('$runtimeType: $message');
    if (cause != null) buf.write('\nCaused by: $cause');
    return buf.toString();
  }
}

/// The WebSocket connection could not be opened, was closed unexpectedly,
/// or the handshake failed for a non-auth reason.
final class ObsConnectionException extends ObsException {
  const ObsConnectionException(super.message, {super.cause, super.stackTrace});
}

/// The `Identify` / `Identified` handshake failed (wrong password,
/// unsupported RPC version, missing Hello, etc).
final class ObsAuthenticationException extends ObsException {
  const ObsAuthenticationException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

/// An OBS `Request` returned a non-success [RequestStatus].
///
/// [code] is the OBS WebSocket status code and [comment] is the
/// server-supplied explanation, when present.
final class ObsRequestException extends ObsException {
  final String requestType;
  final int code;
  final String? comment;

  ObsRequestException({
    required this.requestType,
    required this.code,
    this.comment,
    StackTrace? stackTrace,
  }) : super(
         'Request $requestType failed (code $code)'
         '${comment != null ? ': $comment' : ''}',
         stackTrace: stackTrace,
       );
}

/// Invalid argument supplied to the obs_websocket API surface
/// (e.g. malformed URL, wrong event subscription type).
final class ObsArgumentException extends ObsException {
  const ObsArgumentException(super.message, {super.cause, super.stackTrace});
}
