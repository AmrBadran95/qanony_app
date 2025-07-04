import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Core/shared/logincache.dart';

part 'decider_state.dart';

class DeciderCubit extends Cubit<DeciderState> {
  DeciderCubit() : super(DeciderInitial());
  Future<void> checkDeciderState() async {
    final done = await SharedHelper.getOnboardingDone();
    if (done) {
      emit(DeciderChooseRole());
    } else {
      emit(DeciderOnboarding());
    }
  }

}
