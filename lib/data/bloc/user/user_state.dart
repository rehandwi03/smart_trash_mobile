part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserGetSuccess extends UserState {
  final List<UserResponse> response;

  const UserGetSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class UserGetError extends UserState {}

final class UserGetLoading extends UserState {}

// add user
final class UserAddSuccess extends UserState {}

final class UserAddLoading extends UserState {}

final class UserAddError extends UserState {
  final String message;

  const UserAddError({required this.message});

  @override
  List<Object> get props => [message];
}

// delete user
final class UserDeleteSuccess extends UserState {}

final class UserDeleteLoading extends UserState {}

final class UserDeleteError extends UserState {
  final String message;

  const UserDeleteError({required this.message});

  @override
  List<Object> get props => [message];
}
