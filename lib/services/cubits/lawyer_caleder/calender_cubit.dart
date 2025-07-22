import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

part 'caleder_state.dart';

class LawyerScheduleCubit extends Cubit<LawyerScheduleState> {
  LawyerScheduleCubit() : super(LawyerScheduleInitial());

  DateTime selectedDate = DateTime.now();
  int weekOffset = 0;
  List<DateTime> appointments = [];

  late String _lawyerId;

  List<DateTime> getWeekDates() {
    final today = DateTime.now().add(Duration(days: 7 * weekOffset));
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void changeWeek(int offset) async {
    await saveToFirestore();
    weekOffset += offset;
    emit(LawyerScheduleUpdated());
  }

  Future<void> selectDate(
    BuildContext context,
    String lawyerId,
    DateTime date, [
    int? indexToEdit,
  ]) async {
    _lawyerId = lawyerId;

    final initial = indexToEdit != null ? appointments[indexToEdit] : date;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time != null) {
      final updated = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      if (indexToEdit != null) {
        appointments[indexToEdit] = updated;
      } else {
        appointments.add(updated);
      }

      selectedDate = updated;

      await saveToFirestore();
      emit(LawyerScheduleUpdated());
    }
  }

  Future<void> deleteAppointment(String lawyerId, int index) async {
    _lawyerId = lawyerId;
    appointments.removeAt(index);
    await saveToFirestore();
    emit(LawyerScheduleUpdated());
  }

  Future<void> loadAppointments(String lawyerId) async {
    _lawyerId = lawyerId;
    final doc = await FirebaseFirestore.instance
        .collection('lawyers')
        .doc(lawyerId)
        .get();

    final data = doc.data();
    final list = data?['availableAppointments'] ?? [];

    appointments = List<DateTime>.from(
      list.map((item) {
        if (item is Timestamp) {
          return item.toDate();
        } else if (item is Map && item['datetime'] is Timestamp) {
          return (item['datetime'] as Timestamp).toDate();
        } else if (item is Map && item['date'] is Timestamp) {
          return (item['date'] as Timestamp).toDate();
        } else if (item is String) {
          return DateTime.parse(item);
        } else {
          return DateTime.now(); // fallback
        }
      }),
    );

    emit(LawyerScheduleUpdated());
  }

  Future<void> saveToFirestore() async {
    if (_lawyerId.isEmpty) return;

    final datesList = appointments.map((dt) => Timestamp.fromDate(dt)).toList();

    await FirebaseFirestore.instance
        .collection('lawyers')
        .doc(_lawyerId)
        .update({'availableAppointments': datesList});

    emit(LawyerScheduleUpdated());
  }
}
