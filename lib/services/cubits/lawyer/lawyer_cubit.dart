import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/models/lawyer_model.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

import 'lawyer_state.dart';

class LawyerCubit extends Cubit<LawyerState> {
  final LawyerFirestoreService _service;
  LawyerModel? _currentLawyer;
  bool _isLocalUpdate = false;

  StreamSubscription? _lawyerStreamSubscription;
  bool _ignoreNextUpdate = false;

  LawyerCubit(this._service) : super(LawyerInitial());

  void getLawyerById(String lawyerId) async {
    emit(LawyerLoading());
    _lawyerStreamSubscription?.cancel();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(lawyerId)
          .get();

      if (doc.exists) {
        _currentLawyer = LawyerModel.fromJson(doc.data()!);
        emit(LawyerLoaded(_currentLawyer!));
      } else {
        emit(LawyerError("المحامي غير موجود"));
        return;
      }
    } catch (e) {
      print("🔥 Exception caught while fetching lawyer: $e");
      emit(LawyerError("فشل في تحميل بيانات المحامي"));
      return;
    }

    // ✅ الاشتراك في التحديثات بعد أول تحميل
    _lawyerStreamSubscription = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(lawyerId)
        .snapshots()
        .listen(
          (doc) {
            if (_isLocalUpdate) {
              _isLocalUpdate = false;
              return;
            }

            if (doc.exists) {
              _currentLawyer = LawyerModel.fromJson(doc.data()!);
              emit(LawyerLoaded(_currentLawyer!));
            } else {
              emit(LawyerError("المحامي غير موجود"));
            }
          },
          onError: (e) {
            emit(LawyerError("حدث خطأ: ${e.toString()}"));
          },
        );
  }

  Future<void> editLawyerData(
    String lawyerId,

    Map<String, dynamic> updatedData,
  ) async {
    emit(LawyerUpdating());
    _isLocalUpdate = true;
    try {
      // 1. أولاً: تحديث البيانات المحلية
      if (_currentLawyer != null) {
        _currentLawyer = _currentLawyer!.copyWith(
          specialty: updatedData['specialty'],
        );
        emit(LawyerLoaded(_currentLawyer!)); // ⬅️تحديث وحيد للواجهة
      }

      // ثم تحديث Firestore
      await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(lawyerId)
          .update(updatedData);
    } catch (e) {
      _isLocalUpdate = false;
      emit(LawyerError("فشل في تحديث البيانات"));
      if (_currentLawyer != null) {
        emit(LawyerLoaded(_currentLawyer!));
      }
    }
  }

  @override
  Future<void> close() {
    _lawyerStreamSubscription?.cancel();
    return super.close();
  }
}
