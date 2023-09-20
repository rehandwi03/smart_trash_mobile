part of 'login_bloc.dart';

@immutable
sealed class LoginBlocEvent {}

class LoginEvent extends LoginBlocEvent {
  final LoginRequest req;
  LoginEvent(this.req);
  @override
  List<Object> get props => [req];
}
