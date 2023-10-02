import 'package:flutter/material.dart';
import 'package:smart_trash_mobile/data/models/login.dart';
import 'package:smart_trash_mobile/data/repositories/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginInitialState()) {
    on<LoginEvent>(
      (event, emit) async {
        emit(LoginLoadingState());
        try {
          final token = await _loginRepository.login(event.req);
          emit(LoginSuccessState(token));
        } catch (e) {
          print(e);
          emit(LoginErrorState(message: e.toString()));
        }
      },
    );
  }
}
