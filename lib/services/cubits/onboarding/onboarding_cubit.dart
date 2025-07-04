import 'package:bloc/bloc.dart';

import '../../../Core/shared/logincache.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial(pageIndex: 0));

  void changePage(int index) {
    emit(OnboardingInitial(pageIndex: index));
  }

  Future<void> completeOnboarding() async {
    await SharedHelper.saveOnboardingDone(true);
    emit(OnboardingSkipped());
  }
}
