import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/lawyer_model.dart';

class LawyerRepository {
  final FirebaseFirestore _firestore;

  LawyerRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<LawyerModel?> fetchLawyerById(String uid) async {
    try {
      final doc = await _firestore.collection('lawyers').doc(uid).get();
      if (doc.exists) {
        return LawyerModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching lawyer: $e");
      rethrow;
    }
  }
}
