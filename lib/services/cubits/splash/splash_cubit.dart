import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/app_cache.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initializeApp() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      await AppCache.reload();

      final bool isFirstLaunch = AppCache.isFirstLaunch;
      final bool isLoggedIn = AppCache.isLoggedIn;
      final bool isLawyer = AppCache.isLawyer;
      final String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (isFirstLaunch) {
        emit(SplashFirstLaunch());
      } else if (!isLoggedIn) {
        emit(SplashChooseRole());
      } else if (isLoggedIn && isLawyer) {
        if (uid == null) {
          emit(SplashError());
          return;
        }

        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('lawyers')
            .doc(uid)
            .get();

        if (!snapshot.exists) {
          emit(SplashFirstLaunch());
          return;
        }

        final data = snapshot.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('status')) {
          emit(SplashError());
          return;
        }

        final String status = data['status'];

        if (status == 'pending') {
          emit(SplashLoggedInLawyerPending());
        } else if (status == 'accepted') {
          emit(SplashLoggedInLawyerAccepted());
        } else if (status == 'rejected') {
          emit(SplashLoggedInLawyerRejected());
        } else {
          emit(SplashError());
        }
      } else {
        emit(SplashLoggedInUser());
      }
    } catch (e) {
      emit(SplashError());
    }
  }
}
