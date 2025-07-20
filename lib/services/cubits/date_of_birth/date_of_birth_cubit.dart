import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'date_of_birth_state.dart';

class DateOfBirthCubit extends Cubit<DateOfBirthState> {
  DateOfBirthCubit() : super(DateOfBirthInitial());

  void selectDate(DateTime date) {
    emit(DateOfBirthSelected(date));
  }

  void clearDate() {
    emit(DateOfBirthInitial());
  }
}
