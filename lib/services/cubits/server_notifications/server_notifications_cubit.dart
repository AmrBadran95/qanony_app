import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qanony/data/repos/server_notifications_repo.dart';

part 'server_notifications_state.dart';

class ServerNotificationsCubit extends Cubit<ServerNotificationsState> {
  final ServerNotificationsRepo _repo;

  ServerNotificationsCubit(this._repo) : super(ServerNotificationsInitial());

  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    emit(ServerNotificationsLoading());

    try {
      await _repo.sendNotification(
        fcmToken: fcmToken,
        title: title,
        body: body,
        data: data,
      );
      emit(ServerNotificationsSuccess());
    } catch (e) {
      emit(ServerNotificationsError(e.toString()));
    }
  }
}
