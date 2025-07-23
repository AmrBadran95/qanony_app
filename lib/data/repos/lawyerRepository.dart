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
  Future<List<LawyerModel>> fetchAllLawyers() async {
    try {
      final snapshot = await _firestore.collection('lawyers').get();
      return snapshot.docs
          .map((doc) => LawyerModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(' فشل تحميل المحامين المميزين: $e');
    }
  }
  Future<List<LawyerModel>> fetchPremiumLawyers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('lawyers')
        .where('subscriptionType', isNotEqualTo: 'free')
        .get();

    return snapshot.docs
        .map((doc) => LawyerModel.fromJson(doc.data()))
        .toList();
  }


}
