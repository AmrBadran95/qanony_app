import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/models/user_model.dart';
import 'package:qanony/services/firestore/user_firestore_service.dart';

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

    final user = UserModel(uid: uid, email: email, phone: phone);

    try {
      await UserFirestoreService().createUser(user);
      emit(UserConfirmationSuccess());
    } catch (e) {
      emit(UserConfirmationFailure(e.toString()));
    }
  }
}
