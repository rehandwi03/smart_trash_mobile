import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

part 'websocket_event.dart';
part 'websocket_state.dart';

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  final wsUrl = Uri.parse('ws://0969-114-124-209-23.ngrok-free.app/ws');

  WebsocketBloc() : super(WebsocketInitial()) {
    WebSocketChannel? channel;

    on<WebsocketMessageEvent>((event, emit) {
      channel?.stream.listen((message) {
        print("$message.toString()");
      });
    });

    on<WebsocketConnectEvent>((event, emit) {
      var ch = WebSocketChannel.connect(wsUrl);
      channel = ch;
    });

    on<WebsocketDisconnectEvent>((event, emit) {
      channel?.sink.close();
    });
  }
}
