import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/data/models/user_model.dart';
import 'package:qanony/services/call/call_service.dart';
import 'package:qanony/services/firestore/user_firestore_service.dart';
import 'package:qanony/services/helpers/firebase_errors.dart';
import 'package:qanony/services/notifications/fcm_service.dart';

part 'user_confirmation_state.dart';

class UserConfirmationCubit extends Cubit<UserConfirmationState> {
  final String uid;
  final String email;
  final String phone;

  UserConfirmationCubit({
    required this.uid,
    required this.email,
    required this.phone,
  }) : super(UserConfirmationInitial());

  Future<void> submitUserData({
    required String uid,
    required String email,
    required String phone,
  }) async {
    emit(UserConfirmationLoading());

    try {
      final token = await FirebaseMessaging.instance.getToken();
      final userName = email.split('@')[0];

      final user = UserModel(
        uid: uid,
        email: email,
        phone: phone,
        fcmToken: token,
      );

      await UserFirestoreService().createUser(user);

      AppCache.saveUserId(uid);
      AppCache.saveUserName(userName);
      await FCMHandler.instance.initializeFCM(uid, 'user');
      await CallService().onUserLogin(uid, userName);

      emit(UserConfirmationSuccess());
    } catch (e) {
      emit(UserConfirmationFailure(FirebaseErrorHandler.handle(e)));
    }
  }
}
