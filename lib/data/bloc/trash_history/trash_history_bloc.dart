import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/data/repositories/trash_repository.dart';

part 'trash_history_event.dart';
part 'trash_history_state.dart';

class TrashHistoryBloc extends Bloc<TrashHistoryEvent, TrashHistoryState> {
  TrashRepository _trashRepository;
  List<TrashHistory> histories = [];

  TrashHistoryBloc(this._trashRepository) : super(TrashHistoryInitial()) {
    on<GetTrashHistoryEvent>((event, emit) async {
      emit(GetTrashHistoryLoadingState());
      try {
        final res = await _trashRepository.getHistories(
            startDate: event.startDate, endDate: event.endDate);
        histories = res;
        emit(GetTrashHistorySuccessState(response: res));
      } catch (e) {
        emit(GetTrashHistoryErrorState());
      }
    });
  }
}
