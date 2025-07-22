import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/services/auth/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();

  AuthCubit() : super(AuthInitial());

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.registerWithEmail(email, password);
      emit(AuthRegistered(user!.uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithEmail(email, password);
      if (user == null) throw Exception('User not found');

      final lawyerDoc = await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(user.uid)
          .get();

      if (lawyerDoc.exists) {
        final status = lawyerDoc.data()?['status'] ?? 'pending';

        await AppCache.setIsLawyer(true);
        await AppCache.setLoggedIn(true);
        emit(AuthLoggedInWithStatus(user.uid, status));
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          await AppCache.setIsLawyer(false);
          await AppCache.setLoggedIn(true);
          emit(AuthLoggedIn(user.uid));
        } else {
          await AppCache.setIsLawyer(true);
          await AppCache.setLoggedIn(true);
          emit(
            AuthLawyerNeedsInfo(
              user.uid,
              user.email ?? '',
              user.phoneNumber ?? AppCache.getPhone() ?? '',
            ),
          );
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await AppCache.setLoggedIn(false);
    emit(AuthUnauthenticated());
  }
}
