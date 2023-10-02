part of 'trash_history_bloc.dart';

sealed class TrashHistoryEvent extends Equatable {
  const TrashHistoryEvent();

  @override
  List<Object> get props => [];
}

final class GetTrashHistoryEvent extends TrashHistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetTrashHistoryEvent({this.startDate, this.endDate});
  @override
  List<Object> get props => [];
}
