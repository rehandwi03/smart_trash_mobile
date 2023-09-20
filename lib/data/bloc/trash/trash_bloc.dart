import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/data/repositories/trash_repository.dart';

part 'trash_event.dart';
part 'trash_state.dart';

class TrashBloc extends Bloc<TrashEvent, TrashState> {
  TrashRepository _trashRepository;
  TrashBloc(this._trashRepository) : super(GetTrashHistoryLoadingState()) {
    on<GetTrashHistoryEvent>((event, emit) async {
      emit(UnlockTrashLoadingState());
      try {
        final histories = await _trashRepository.getHistories();
        emit(GetTrashHistorySuccessState(response: histories));
      } catch (e) {
        emit(GetTrashHistoryErrorState());
      }
    });

    on<UnlockTrashEvent>((event, emit) {
      emit(UnlockTrashLoadingState());
      try {
        _trashRepository.unlockTrash();
        emit(UnlockTrashSuccessState());
      } catch (e) {
        emit(UnlockTrashErrorState());
      }
    });

    on<LockTrashEvent>((event, emit) {
      emit(LockTrashLoadingState());
      try {
        _trashRepository.unlockTrash();
        emit(LockTrashSuccessState());
      } catch (e) {
        emit(LockTrashErrorState());
      }
    });
  }
}
