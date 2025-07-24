part of 'gemini_cubit.dart';

abstract class GeminiState {}

class GeminiInitial extends GeminiState {}

class GeminiLoading extends GeminiState {}

class GeminiSuccess extends GeminiState {
  final String response;
  GeminiSuccess(this.response);
}

class GeminiFailure extends GeminiState {
  final String error;
  GeminiFailure(this.error);
}
