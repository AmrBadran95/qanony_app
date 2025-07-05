import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/app_cache.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  Future<void> completeOnboarding() async {
    await AppCache.setFirstLaucnch(false);
    emit(OnboardingSkipped());
  }
}
