import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qanony/data/repos/stripe_connect_repo.dart';

part 'connect_state.dart';

class ConnectCubit extends Cubit<ConnectState> {
  final ConnectRepo _connectRepo;

  ConnectCubit(this._connectRepo) : super(ConnectInitial());

  Future<void> startOnboarding({
    required String lawyerId,
    required String email,
  }) async {
    emit(ConnectLoading());
    try {
      final url = await _connectRepo.createConnectAccount(
        lawyerId: lawyerId,
        email: email,
      );
      emit(ConnectUrlLoaded(url));
    } catch (e) {
      emit(ConnectError(e.toString()));
    }
  }
}
