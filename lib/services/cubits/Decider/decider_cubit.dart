import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../Core/shared/logincache.dart';

part 'decider_state.dart';

class DeciderCubit extends Cubit<DeciderState> {
  DeciderCubit() : super(DeciderInitial());
  Future<void> checkDeciderState() async {
    emit(DeciderOnboarding());
    final done = await SharedHelper.getOnboardingDone();
    if (done) {
      emit(DeciderChooseRole());
    } else {
      emit(DeciderOnboarding());
    }
  }
}
