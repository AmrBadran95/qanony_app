part of 'lawyer_info_cubit.dart';

@immutable
abstract class LawyerInfoState {}

class LawyerInitial extends LawyerInfoState {}

class LawyerLoading extends LawyerInfoState {}

class LawyerLoaded extends LawyerInfoState {
  final LawyerModel lawyer;

  LawyerLoaded(this.lawyer);
}

class LawyerUpdating extends LawyerInfoState {}

class LawyerError extends LawyerInfoState {
  final String message;

  LawyerError(this.message);
}
