part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final LoginResponse response;
  LoginSuccessState(this.response);

  @override
  List<Object> get props => [response];
}

final class LoginErrorState extends LoginState {}
