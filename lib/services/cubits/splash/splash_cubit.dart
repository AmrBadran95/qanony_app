import 'package:bloc/bloc.dart';
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

      if (isFirstLaunch) {
        emit(SplashFirstLaunch());
      } else if (isLoggedIn == false) {
        emit(SplashChooseRole());
      } else if (isLoggedIn == true && isLawyer == true) {
        emit(SplashLoggedInLawyer());
      } else {
        emit(SplashLoggedInUser());
      }
    } catch (error) {
      emit(SplashError());
      debugPrint('Splash Init Error: $error');
    }
  }
}
