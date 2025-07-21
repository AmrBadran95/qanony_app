part of 'lawyer_cubit.dart';

abstract class LawyerState {}

class LawyerInitial extends LawyerState {}

class LawyerLoading extends LawyerState {}

class LawyerLoaded extends LawyerState {
  final LawyerModel lawyer;

  LawyerLoaded(this.lawyer);
}

class LawyerError extends LawyerState {
  final String message;

  LawyerError(this.message);
}
