import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'registration_date_state.dart';

class RegistrationDateCubit extends Cubit<RegistrationDateState> {
  RegistrationDateCubit() : super(RegistrationDateInitial());

  void selectDate(DateTime date) {
    emit(RegistrationDateSelected(date));
  }

  void clearDate() {
    emit(RegistrationDateInitial());
  }
}
