import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

/// Private access via an internal helper is unavailable, so we exercise
/// the normalizer indirectly through the public behaviour:
/// - `connect()` would actually open a socket, which we don't want in a
///   unit test. The normalizer is invoked synchronously *before* the
///   async connection, so passing a bad URL throws synchronously.
void main() {
  group('ObsException hierarchy', () {
    test('is a sealed ObsException', () {
      const conn = ObsConnectionException('x');
      const auth = ObsAuthenticationException('x');
      final req = ObsRequestException(requestType: 'X', code: 100);
      const arg = ObsArgumentException('x');

      expect(conn, isA<ObsException>());
      expect(auth, isA<ObsException>());
      expect(req, isA<ObsException>());
      expect(arg, isA<ObsException>());
    });

    test('ObsRequestException embeds code and comment in message', () {
      final req = ObsRequestException(
        requestType: 'GetVersion',
        code: 600,
        comment: 'nope',
      );

      expect(req.requestType, 'GetVersion');
      expect(req.code, 600);
      expect(req.comment, 'nope');
      expect(req.message, contains('GetVersion'));
      expect(req.message, contains('600'));
      expect(req.message, contains('nope'));
    });

    test('toString includes the cause when present', () {
      final inner = StateError('boom');
      final outer = ObsConnectionException('wrap', cause: inner);
      expect(outer.toString(), contains('ObsConnectionException'));
      expect(outer.toString(), contains('Caused by'));
      expect(outer.toString(), contains('boom'));
    });
  });

  group('ObsWebSocket.connect URL validation', () {
    test('rejects an http:// URL with ObsArgumentException', () async {
      await expectLater(
        ObsWebSocket.connect('http://localhost:4455'),
        throwsA(isA<ObsArgumentException>()),
      );
    });

    test('rejects a malformed URL', () async {
      await expectLater(
        ObsWebSocket.connect('::::not a url'),
        throwsA(isA<ObsArgumentException>()),
      );
    });
  });
}
