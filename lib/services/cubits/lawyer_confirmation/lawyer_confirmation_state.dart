part of 'lawyer_confirmation_cubit.dart';

@immutable
sealed class LawyerConfirmationState {}

final class LawyerConfirmationInitial extends LawyerConfirmationState {}

class LawyerConfirmationValidationSuccess extends LawyerConfirmationState {}

class LawyerConfirmationValidationError extends LawyerConfirmationState {
  final String message;
  LawyerConfirmationValidationError(this.message);
}

class LawyerConfirmationSubmitted extends LawyerConfirmationState {}

class LawyerConfirmationSubmissionFailed extends LawyerConfirmationState {
  final String message;
  LawyerConfirmationSubmissionFailed(this.message);
}
