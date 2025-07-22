part of 'lawyer_rejection_cubit.dart';

@immutable
abstract class LawyerRejectionState {}

class LawyerRejectionInitial extends LawyerRejectionState {}

class LawyerRejectionLoading extends LawyerRejectionState {}

class LawyerRejectionLoaded extends LawyerRejectionState {
  final List<String> reasons;
  LawyerRejectionLoaded(this.reasons);
}

class LawyerRejectionEmpty extends LawyerRejectionState {}

class LawyerRejectionDeleted extends LawyerRejectionState {}

class LawyerRejectionError extends LawyerRejectionState {}
