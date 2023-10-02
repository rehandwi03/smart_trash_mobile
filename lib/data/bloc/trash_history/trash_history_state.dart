part of 'trash_history_bloc.dart';

sealed class TrashHistoryState extends Equatable {
  const TrashHistoryState();

  @override
  List<Object> get props => [];
}

final class TrashHistoryInitial extends TrashHistoryState {}

final class GetTrashHistorySuccessState extends TrashHistoryState {
  final List<TrashHistory> response;

  const GetTrashHistorySuccessState({required this.response});

  @override
  List<Object> get props => [response];
}

final class GetTrashHistoryLoadingState extends TrashHistoryState {
  @override
  List<Object> get props => [];
}

final class GetTrashHistoryErrorState extends TrashHistoryState {
  @override
  List<Object> get props => [];
}
