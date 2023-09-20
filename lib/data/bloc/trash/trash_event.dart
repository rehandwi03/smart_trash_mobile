part of 'trash_bloc.dart';

sealed class TrashEvent extends Equatable {
  const TrashEvent();

  @override
  List<Object> get props => [];
}

final class UnlockTrashEvent extends TrashEvent {
  @override
  List<Object> get props => [];
}

final class LockTrashEvent extends TrashEvent {
  @override
  List<Object> get props => [];
}

final class GetTrashHistoryEvent extends TrashEvent {
  @override
  List<Object> get props => [];
}
