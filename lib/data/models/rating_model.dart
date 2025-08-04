import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String userId;
  final String lawyerId;
  final String name;
  final String comment;
  final double rating;
  final DateTime date;

  RatingModel({
    required this.userId,
    required this.lawyerId,
    required this.name,
    required this.comment,
    required this.rating,
    required this.date,
  });

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      userId: map['userId'] ?? '',
      lawyerId: map['lawyerId'] ?? '',
      name: map['name'] ?? 'مستخدم',
      comment: map['comment'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lawyerId': lawyerId,
      'name': name,
      'comment': comment,
      'rating': rating,
      'date': date,
    };
  }
}
