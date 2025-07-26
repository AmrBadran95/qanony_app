import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qanony/data/models/order_status_enum.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String lawyerId;
  final OrderStatus status;
  final DateTime date;
  final String userName;
  final String caseType;
  final String caseDescription;
  final String contactMethod;
  final double price;
  final String? meetingLink;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.lawyerId,
    this.status = OrderStatus.pending,
    required this.date,
    this.userName = "عميل غير معروف",
    this.caseType = "أخرى",
    required this.caseDescription,
    required this.contactMethod,
    required this.price,
    this.meetingLink,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json["orderId"] ?? '',
      userId: json["userId"] ?? '',
      lawyerId: json["lawyerId"] ?? '',
      status: orderStatusFromString(json["status"] ?? 'pending'),
      date: (json['date'] as Timestamp).toDate(),
      userName: json["userName"] ?? "عميل غير معروف",
      caseType: json["caseType"] ?? "أخرى",
      caseDescription: json["caseDescription"] ?? '',
      contactMethod: json["contactMethod"] ?? '',
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : (json["price"] ?? 0).toDouble(),
      meetingLink: json["meetingLink"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "lawyerId": lawyerId,
      "status": orderStatusToString(status),
      "date": Timestamp.fromDate(date),
      "userName": userName,
      "caseType": caseType,
      "caseDescription": caseDescription,
      "contactMethod": contactMethod,
      "price": price,
      "meetingLink": meetingLink,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "lawyerId": lawyerId,
      "status": orderStatusToString(status),
      "date": Timestamp.fromDate(date),
      "userName": userName,
      "caseType": caseType,
      "caseDescription": caseDescription,
      "contactMethod": contactMethod,
      "price": price,
      "meetingLink": meetingLink,
    };
  }

  OrderModel copyWith({
    String? orderId,
    String? userId,
    String? lawyerId,
    OrderStatus? status,
    DateTime? date,
    String? userName,
    String? caseType,
    String? caseDescription,
    String? contactMethod,
    double? price,
    String? meetingLink,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      lawyerId: lawyerId ?? this.lawyerId,
      status: status ?? this.status,
      date: date ?? this.date,
      userName: userName ?? this.userName,
      caseType: caseType ?? this.caseType,
      caseDescription: caseDescription ?? this.caseDescription,
      contactMethod: contactMethod ?? this.contactMethod,
      price: price ?? this.price,
      meetingLink: meetingLink ?? this.meetingLink,
    );
  }
}
