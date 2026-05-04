import 'package:obs_websocket/src/connect.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebConnect implements Connect {
  @override
  Future<WebSocketChannel> connect({
    required String connectUrl,
    timeout = const Duration(seconds: 30),
  }) async {
    final htmlWebsocketChannel = HtmlWebSocketChannel.connect(connectUrl);

    return htmlWebsocketChannel;
  }
}

Connect getConnect() => WebConnect();
