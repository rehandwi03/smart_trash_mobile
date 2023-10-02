part of 'trash_bloc.dart';

sealed class TrashEvent extends Equatable {
  const TrashEvent();

  @override
  List<Object> get props => [];
}

final class GetAllTrashEvent extends TrashEvent {}

final class GetReportPerDay extends TrashEvent {}

final class UnlockTrashEvent extends TrashEvent {
  @override
  List<Object> get props => [];
}

final class LockTrashEvent extends TrashEvent {
  @override
  List<Object> get props => [];
}
