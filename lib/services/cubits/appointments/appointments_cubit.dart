import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsInitial());

  String? selectedSpecialty;

  final CollectionReference appointmentsRef = FirebaseFirestore.instance
      .collection('appointments');

  Stream<QuerySnapshot> getAppointmentsStream() {
    return appointmentsRef.snapshots();
  }

  Future<void> addAppointment({
    required String name,
    required String specialty,
    required String description,
    required String communication,
    required DateTime date,
  }) async {
    try {
      await appointmentsRef.add({
        'name': name,
        'specialty': specialty,
        'description': description,
        'communication': communication,
        'date': Timestamp.fromDate(date),
      });
      emit(AppointmentAdded()); // ✅ حالة النجاح
    } catch (e) {
      emit(AppointmentsError("فشل في إضافة الموعد: ${e.toString()}"));
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await appointmentsRef.doc(id).delete();
      emit(AppointmentDeleted()); // ✅ حالة النجاح
    } catch (e) {
      emit(AppointmentsError("فشل في حذف الموعد: ${e.toString()}"));
    }
  }

  void changeSpecialty(String? value) {
    selectedSpecialty = value;
    emit(SpecialtyChanged(value));
  }

  Future<void> updateAppointment({
    required String id,
    required String name,
    required String specialty,
    required String description,
    required String communication,
    required DateTime date,
  }) async {
    try {
      await appointmentsRef.doc(id).update({
        'name': name,
        'specialty': specialty,
        'description': description,
        'communication': communication,
        'date': Timestamp.fromDate(date),
      });
      emit(AppointmentUpdated());
    } catch (e) {
      emit(AppointmentsError("فشل في تعديل الموعد: ${e.toString()}"));
    }
  }
}
