import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());

  void selectDate(DateTime date) {
    emit(CalendarSelected(date));
  }

  void clearDate() {
    emit(CalendarInitial());
  }
}
