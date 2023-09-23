part of 'trash_bloc.dart';

sealed class TrashState extends Equatable {
  const TrashState();

  @override
  List<Object> get props => [];
}

final class TrashInitial extends TrashState {
  @override
  List<Object> get props => [];
}

final class TrashReportPerDayLoadingState extends TrashState {}

final class TrashReportPerDayFailedState extends TrashState {
  final String message;

  const TrashReportPerDayFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

final class TrashReportPerDaySuccessState extends TrashState {
  final ReportPerDay response;

  const TrashReportPerDaySuccessState({required this.response});

  @override
  List<Object> get props => [response];
}

final class GetTrashHistorySuccessState extends TrashState {
  final List<TrashHistory> response;

  const GetTrashHistorySuccessState({required this.response});

  @override
  List<Object> get props => [response];
}

final class GetTrashHistoryLoadingState extends TrashState {
  @override
  List<Object> get props => [];
}

final class GetTrashHistoryErrorState extends TrashState {
  @override
  List<Object> get props => [];
}

//
//unlock trash
final class UnlockTrashSuccessState extends TrashInitial {
  @override
  List<Object> get props => [];
}

final class UnlockTrashErrorState extends TrashState {
  @override
  List<Object> get props => [];
}

final class UnlockTrashLoadingState extends TrashState {
  @override
  List<Object> get props => [];
}

// lock trash
final class LockTrashSuccessState extends TrashInitial {
  @override
  List<Object> get props => [];
}

final class LockTrashErrorState extends TrashState {
  @override
  List<Object> get props => [];
}

final class LockTrashLoadingState extends TrashState {
  @override
  List<Object> get props => [];
}
