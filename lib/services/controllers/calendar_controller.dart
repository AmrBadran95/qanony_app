import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/services/cubits/calendar/calendar_cubit.dart';

class CalendarController {
  static DateTime? getSelectedDate(CalendarState state) {
    if (state is CalendarSelected) {
      return state.selectedDate;
    }
    return null;
  }

  static void updateDate(BuildContext context, DateTime date) {
    context.read<CalendarCubit>().selectDate(date);
  }
}
