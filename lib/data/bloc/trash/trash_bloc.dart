import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/data/repositories/trash_repository.dart';

part 'trash_event.dart';
part 'trash_state.dart';

class TrashBloc extends Bloc<TrashEvent, TrashState> {
  TrashRepository _trashRepository;
  int? totalReportPerDay;
  List<TrashHistory> histories = [];
  TrashBloc(this._trashRepository) : super(TrashInitial()) {
    on<GetAllTrashEvent>((event, emit) async {
      emit(GetAllTrashLoadingState());
      try {
        final response = await _trashRepository.getAllTrash();
        emit(GetAllTrashSuccessState(response: response));
      } catch (e) {
        emit(GetAllTrashFailedState(message: e.toString()));
      }
    });

    on<GetReportPerDay>((event, emit) async {
      emit(TrashReportPerDayLoadingState());
      try {
        final response = await _trashRepository.getReportPerDay();
        totalReportPerDay = response.data;
        emit(TrashReportPerDaySuccessState(response: response));
      } catch (e) {
        emit(TrashReportPerDayFailedState(message: e.toString()));
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
        _trashRepository.lockTrash();
        emit(LockTrashSuccessState());
      } catch (e) {
        emit(LockTrashErrorState());
      }
    });
  }
}
