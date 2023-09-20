import 'package:equatable/equatable.dart';
import 'package:smart_trash_mobile/data/models/user.dart';
import 'package:smart_trash_mobile/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc(this._userRepository) : super(UserInitial()) {
    on<UserGetEvent>((event, emit) async {
      emit(UserGetLoading());
      try {
        final users = await this._userRepository.getAllUser();

        emit(UserGetSuccess(users));
      } catch (e) {
        emit(UserGetError());
      }
    });

    on<UserAddEvent>(
      (event, emit) async {
        emit(UserAddLoading());
        try {
          await this._userRepository.addUser(event.request);
          emit(UserAddSuccess());
        } catch (e) {
          emit(UserAddError());
        }
      },
    );

    on<UserDeleteEvent>(
      (event, emit) async {
        emit(UserDeleteLoading());
        try {
          await this._userRepository.deleteUser(event.request);
          emit(UserDeleteSuccess());
        } catch (e) {
          emit(UserDeleteError());
        }
      },
    );
  }
}
