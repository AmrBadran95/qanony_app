import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

part 'lawyer_rejection_state.dart';

class LawyerRejectionCubit extends Cubit<LawyerRejectionState> {
  final LawyerFirestoreService _service = LawyerFirestoreService();

  LawyerRejectionCubit() : super(LawyerRejectionInitial());

  Future<void> fetchRejectionReason(String? uid) async {
    if (uid == null) {
      emit(LawyerRejectionError());
      return;
    }

    emit(LawyerRejectionLoading());
    try {
      final lawyer = await _service.getLawyerById(uid);
      if (lawyer != null &&
          lawyer.rejectionReasons != null &&
          lawyer.rejectionReasons!.isNotEmpty) {
        emit(LawyerRejectionLoaded(lawyer.rejectionReasons!));
      } else {
        emit(LawyerRejectionEmpty());
      }
    } catch (e) {
      emit(LawyerRejectionError());
    }
  }

  Future<void> deleteLawyerData(String uid) async {
    try {
      await _service.deleteLawyer(uid);

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }

      await AppCache.setLoggedIn(false);
      await AppCache.setIsLawyer(false);

      emit(LawyerRejectionDeleted());
    } catch (e) {
      emit(LawyerRejectionError());
    }
  }
}
