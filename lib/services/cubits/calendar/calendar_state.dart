part of 'calendar_cubit.dart';

@immutable
sealed class CalendarState {}

final class CalendarInitial extends CalendarState {}

final class CalendarSelected extends CalendarState {
  final DateTime selectedDate;

  CalendarSelected(this.selectedDate);
}
