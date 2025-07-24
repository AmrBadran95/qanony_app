import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/lawyer_model.dart';
import '../../../data/repos/lawyer_repository.dart';

part 'lawyer_state.dart';

class LawyerCubit extends Cubit<LawyerState> {
  final LawyerRepository _repository;

  LawyerCubit(this._repository) : super(LawyerInitial());

  Future<void> getLawyer(String uid) async {
    emit(LawyerLoading());
    try {
      final lawyer = await _repository.fetchLawyerById(uid);
      if (lawyer != null) {
        emit(LawyerLoaded(lawyer));
      } else {
        emit(LawyerError("لم يتم العثور على بيانات المحامي"));
      }
    } catch (e) {
      emit(LawyerError("حدث خطأ: $e"));
    }
  }

  Future<void> getAllLawyers() async {
    emit(LawyerLoading());
    try {
      final lawyers = await _repository.fetchAllLawyers();
      emit(LawyersMapedLoaded(lawyers));
    } catch (e) {
      emit(LawyerError("حدث خطأ أثناء جلب جميع المحامين: $e"));
    }
  }

  Future<void> getPremiumLawyers() async {
    emit(LawyerLoading());
    try {
      final lawyers = await _repository.fetchPremiumLawyers();
      emit(LawyersMapedLoaded(lawyers));
    } catch (e) {
      emit(LawyerError("حدث خطأ أثناء تحميل المحامين المميزين: $e"));
    }
  }
}
