part of 'lawyer_confirmation_cubit.dart';

@immutable
sealed class LawyerConfirmationState {}

final class LawyerConfirmationInitial extends LawyerConfirmationState {}

final class LawyerConfirmationLoading extends LawyerConfirmationState {}

final class LawyerConfirmationValidationSuccess
    extends LawyerConfirmationState {}

final class LawyerConfirmationValidationError extends LawyerConfirmationState {
  final String message;
  LawyerConfirmationValidationError(this.message);
}

final class LawyerConfirmationSubmitted extends LawyerConfirmationState {}

final class LawyerConfirmationSubmissionFailed extends LawyerConfirmationState {
  final String message;
  LawyerConfirmationSubmissionFailed(this.message);
}
