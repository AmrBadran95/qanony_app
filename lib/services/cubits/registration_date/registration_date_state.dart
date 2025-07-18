part of 'registration_date_cubit.dart';

@immutable
abstract class RegistrationDateState {}

class RegistrationDateInitial extends RegistrationDateState {}

class RegistrationDateSelected extends RegistrationDateState {
  final DateTime selectedDate;

  RegistrationDateSelected(this.selectedDate);
}
