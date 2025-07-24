import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/repos/gemini_repo.dart';

part 'gemini_state.dart';

class GeminiCubit extends Cubit<GeminiState> {
  final GeminiRepository repo;
  GeminiCubit(this.repo) : super(GeminiInitial());

  Future<void> sendPrompt(String prompt) async {
    emit(GeminiLoading());
    try {
      final response = await repo.getResponse(prompt);
      emit(GeminiSuccess(response));
    } catch (e) {
      emit(GeminiFailure(e.toString()));
    }
  }

  void reset() {
    emit(GeminiInitial());
  }
}
