import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionCubit extends Cubit<bool> {
  SubscriptionCubit() : super(false);

  Future<void> checkSubscription() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(uid)
          .get();

      final data = doc.data();
      final type = data?['subscriptionType'] ?? 'free';
      emit(type != 'free');
    } catch (e) {
      emit(false);
    }
  }
}
