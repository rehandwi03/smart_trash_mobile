part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserDeleteEvent extends UserEvent {
  final UserDeleteRequest request;

  const UserDeleteEvent({required this.request});

  @override
  List<Object> get props => [request];
}

final class UserGetEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

final class UserAddEvent extends UserEvent {
  final UserAddRequest request;

  const UserAddEvent({required this.request});

  @override
  List<Object> get props => [request];
}
