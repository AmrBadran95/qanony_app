import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qanony/data/models/rating_model.dart';

class RatingFirestoreService {
  final _ratingsCollection = FirebaseFirestore.instance.collection('ratings');

  Future<Map<String, dynamic>?> getUserRating({
    required String userId,
    required String lawyerId,
  }) async {
    final query = await _ratingsCollection
        .where('userId', isEqualTo: userId)
        .where('lawyerId', isEqualTo: lawyerId)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    } else {
      return null;
    }
  }

  Future<List<RatingModel>> getAllRatingsForLawyer(String lawyerId) async {
    try {
      final querySnapshot = await _ratingsCollection
          .where('lawyerId', isEqualTo: lawyerId)
          .get();

      final reviews = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return RatingModel.fromMap(data);
      }).toList();

      return reviews;
    } catch (e) {
      print("Error fetching lawyer reviews: $e");
      return [];
    }
  }

  /// Add or update user rating for a lawyer
  Future<void> addOrUpdateRating({
    required String userId,
    required String lawyerId,
    required double rating,
    String? comment,
  }) async {
    final docRef = _ratingsCollection.doc('$userId-$lawyerId');

    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final userName = userSnapshot.data()?['name'] ?? 'مستخدم';

    await docRef.set({
      'userId': userId,
      'lawyerId': lawyerId,
      'rating': rating,
      'comment': comment ?? '',
      'name': userName,
      'date': FieldValue.serverTimestamp(),
    });
  }

  /// Get average rating for a specific lawyer
  Future<double> getAverageRating(String lawyerId) async {
    final snapshot = await _ratingsCollection
        .where('lawyerId', isEqualTo: lawyerId)
        .get();

    if (snapshot.docs.isEmpty) return 0.0;

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['rating'] ?? 0).toDouble();
    }

    return total / snapshot.docs.length;
  }

  /// Get total rating count for a specific lawyer
  Future<int> getRatingCount(String lawyerId) async {
    final snapshot = await _ratingsCollection
        .where('lawyerId', isEqualTo: lawyerId)
        .get();

    return snapshot.docs.length;
  }
}
