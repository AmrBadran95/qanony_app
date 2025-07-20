part of 'user_confirmation_cubit.dart';

@immutable
abstract class UserConfirmationState {}

class UserConfirmationInitial extends UserConfirmationState {}

class UserConfirmationLoading extends UserConfirmationState {}

class UserConfirmationSuccess extends UserConfirmationState {}

class UserConfirmationFailure extends UserConfirmationState {
  final String error;

  UserConfirmationFailure(this.error);
}
