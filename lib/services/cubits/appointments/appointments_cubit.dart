import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsInitial());

  String? selectedSpecialty;

  final CollectionReference appointmentsRef = FirebaseFirestore.instance
      .collection('appointments');

  Stream<QuerySnapshot> getAppointmentsStream() {
    return appointmentsRef
        .where('lawyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
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
        'lawyerId': FirebaseAuth.instance.currentUser!.uid,
      });
      emit(AppointmentAdded());
    } catch (e) {
      emit(AppointmentsError("فشل في إضافة الموعد: ${e.toString()}"));
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      final doc = await appointmentsRef.doc(id).get();
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      if (doc.exists && doc['lawyerId'] == currentUserId) {
        await appointmentsRef.doc(id).delete();
        emit(AppointmentDeleted());
      } else {
        emit(AppointmentsError("ليس لديك صلاحية لحذف هذا الموعد."));
      }
    } catch (e) {
      emit(AppointmentsError("فشل في حذف الموعد: ${e.toString()}"));
    }
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
      final doc = await appointmentsRef.doc(id).get();
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      if (doc.exists && doc['lawyerId'] == currentUserId) {
        await appointmentsRef.doc(id).update({
          'name': name,
          'specialty': specialty,
          'description': description,
          'communication': communication,
          'date': Timestamp.fromDate(date),
        });
        emit(AppointmentUpdated());
      } else {
        emit(AppointmentsError("ليس لديك صلاحية لتعديل هذا الموعد."));
      }
    } catch (e) {
      emit(AppointmentsError("فشل في تعديل الموعد: ${e.toString()}"));
    }
  }

  void changeSpecialty(String? value) {
    selectedSpecialty = value;
    emit(SpecialtyChanged(value));
  }

  Future<void> getQanonyAppointments() async {
    emit(AppointmentsLoading());

    try {
      final snapshot = await appointmentsRef
          .where('status', whereIn: ['accepted_by_lawyer', 'payment_done'])
          .get();

      final data = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      emit(AppointmentsLoaded(data));
    } catch (e) {
      emit(AppointmentsError("فشل في تحميل المواعيد: ${e.toString()}"));
    }
  }
}
