part of 'websocket_bloc.dart';

sealed class WebsocketEvent extends Equatable {
  const WebsocketEvent();

  @override
  List<Object> get props => [];
}

class WebsocketConnectEvent extends WebsocketEvent {}

class WebsocketDisconnectEvent extends WebsocketEvent {}

class WebsocketMessageEvent extends WebsocketEvent {}
