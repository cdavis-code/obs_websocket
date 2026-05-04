import 'dart:io';
import 'package:obs_websocket/src/connect.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IoConnect implements Connect {
  @override
  Future<WebSocketChannel> connect({
    required String connectUrl,
    timeout = const Duration(seconds: 30),
  }) async {
    final websocket = await WebSocket.connect(connectUrl).timeout(timeout);

    return IOWebSocketChannel(websocket);
  }
}

Connect getConnect() => IoConnect();
