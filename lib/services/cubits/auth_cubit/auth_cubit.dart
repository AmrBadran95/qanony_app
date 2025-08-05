import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/services/auth/auth_service.dart';
import 'package:qanony/services/helpers/firebase_errors.dart';
import 'package:qanony/services/notifications/fcm_service.dart';

import '../../call/call_service.dart';

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
      emit(AuthError(FirebaseErrorHandler.handle(e)));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithEmail(email, password);
      if (user == null) throw Exception('User not found');

      final userId = user.uid;
      String role = '';
      final userName = user.displayName ?? user.email?.split('@')[0] ?? "User";

      final lawyerDoc = await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(userId)
          .get();

      if (lawyerDoc.exists) {
        final status = lawyerDoc.data()?['status'] ?? 'pending';
        role = 'lawyer';

        await AppCache.setIsLawyer(true);
        await AppCache.setLoggedIn(true);
        emit(AuthLoggedInWithStatus(userId, status));
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          role = 'user';
          await AppCache.setIsLawyer(false);
          await AppCache.setLoggedIn(true);
          emit(AuthLoggedIn(userId));
        } else {
          role = 'lawyer';
          await AppCache.setIsLawyer(true);
          await AppCache.setLoggedIn(true);
          emit(
            AuthLawyerNeedsInfo(
              userId,
              user.email ?? '',
              user.phoneNumber ?? AppCache.getPhone() ?? '',
            ),
          );
        }
      }
      await CallService().onUserLogin(userId, userName);
      await FCMHandler.instance.initializeFCM(userId, role);
    } catch (e) {
      emit(AuthError(FirebaseErrorHandler.handle(e)));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await AppCache.setLoggedIn(false);
    emit(AuthUnauthenticated());
  }
}
