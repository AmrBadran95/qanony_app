import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../Core/shared/logincash.dart';
part 'onboarding_state.dart';



class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  void changePage(int index) {
    emit(OnboardingInitial(pageIndex: index));
  }

}
