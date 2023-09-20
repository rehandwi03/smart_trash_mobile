import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  Future<void> connect(String url) async {
    _channel = IOWebSocketChannel.connect(url);
  }

  void disconnect() {
    _channel?.sink.close();
  }

  WebSocketChannel? get channel => _channel;
}
