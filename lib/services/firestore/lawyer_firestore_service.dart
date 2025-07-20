import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qanony/data/models/lawyer_model.dart';

class LawyerFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'lawyers';

  Future<void> createLawyer(LawyerModel lawyer) async {
    await _firestore
        .collection(_collection)
        .doc(lawyer.uid)
        .set(lawyer.toJson());
  }

  Future<LawyerModel?> getLawyerById(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists) {
      return LawyerModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateLawyer(LawyerModel lawyer) async {
    await _firestore
        .collection(_collection)
        .doc(lawyer.uid)
        .update(lawyer.toJson());
  }

  Future<void> deleteLawyer(String uid) async {
    await _firestore.collection(_collection).doc(uid).delete();
  }
}
