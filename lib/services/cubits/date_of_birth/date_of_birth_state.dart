part of 'date_of_birth_cubit.dart';

@immutable
abstract class DateOfBirthState {}

class DateOfBirthInitial extends DateOfBirthState {}

class DateOfBirthSelected extends DateOfBirthState {
  final DateTime selectedDate;

  DateOfBirthSelected(this.selectedDate);
}
