part of 'appointments_cubit.dart';

@immutable
abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}

class AppointmentAdded extends AppointmentsState {}

class AppointmentDeleted extends AppointmentsState {}

class SpecialtyChanged extends AppointmentsState {
  final String? specialty;
  SpecialtyChanged(this.specialty);
}

class AppointmentUpdated extends AppointmentsState {}
