part of 'websocket_bloc.dart';

sealed class WebsocketState extends Equatable {
  const WebsocketState();

  @override
  List<Object> get props => [];
}

final class WebsocketInitial extends WebsocketState {}

final class WebsocketConnecting extends WebsocketState {}

final class WebsocketConnected extends WebsocketState {}

final class WebsocketDisconnected extends WebsocketState {}

final class WebsocketMessage extends WebsocketState {}
