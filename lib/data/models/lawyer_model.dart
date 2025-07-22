import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerModel {
  final String uid;
  final String email;
  final String phone;
  final String role;
  final String status;
  final List<String>? rejectionReasons;

  final String? fullName;
  final String? nationalId;
  final String? governorate;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profilePictureUrl;

  final String? bio;
  final String? registrationNumber;
  final DateTime? registrationDate;
  final List<String>? specialty;
  final String? cardImageUrl;

  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;

  final bool? offersCall;
  final double? callPrice;

  final bool? offersOffice;
  final double? officePrice;

  final String subscriptionType;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final List<DateTime> availableAppointments;

  LawyerModel({
    required this.uid,
    required this.email,
    required this.phone,
    this.role = 'lawyer',
    this.status = 'pending',
    this.rejectionReasons,
    this.fullName,
    this.nationalId,
    this.governorate,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.profilePictureUrl,
    this.bio,
    this.registrationNumber,
    this.registrationDate,
    this.specialty,
    this.cardImageUrl,
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.offersCall,
    this.callPrice,
    this.offersOffice,
    this.officePrice,
    this.subscriptionType = 'free',
    this.subscriptionStart,
    this.subscriptionEnd,
    this.availableAppointments = const [],
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return LawyerModel(
      uid: json['uid'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
      rejectionReasons: List<String>.from(json['rejectionReasons'] ?? []),
      fullName: json['fullName'],
      nationalId: json['nationalId'],
      governorate: json['governorate'],
      address: json['address'],
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      registrationNumber: json['registrationNumber'],
      registrationDate: (json['registrationDate'] as Timestamp).toDate(),
      specialty: List<String>.from(json['specialty'] ?? []),
      cardImageUrl: json['cardImageUrl'],
      bankName: json['bankName'],
      accountHolderName: json['accountHolderName'],
      accountNumber: json['accountNumber'],
      offersCall: json['offersCall'],
      callPrice: (json['callPrice'] as num?)?.toDouble(),
      offersOffice: json['offersOffice'],
      officePrice: (json['officePrice'] as num?)?.toDouble(),
      subscriptionType: json['subscriptionType'] ?? 'free',
      subscriptionStart: json['subscriptionStart'] != null
          ? DateTime(
              (json['subscriptionStart'] as Timestamp).toDate().year,
              (json['subscriptionStart'] as Timestamp).toDate().month,
              (json['subscriptionStart'] as Timestamp).toDate().day,
            )
          : null,
      subscriptionEnd: json['subscriptionEnd'] != null
          ? DateTime(
              (json['subscriptionEnd'] as Timestamp).toDate().year,
              (json['subscriptionEnd'] as Timestamp).toDate().month,
              (json['subscriptionEnd'] as Timestamp).toDate().day,
            )
          : null,
      availableAppointments:
          (json['availableAppointments'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'rejectionReasons': rejectionReasons,
      'fullName': fullName,
      'nationalId': nationalId,
      'governorate': governorate,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'registrationNumber': registrationNumber,
      'registrationDate': registrationDate,
      'specialty': specialty,
      'cardImageUrl': cardImageUrl,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'offersCall': offersCall,
      'callPrice': callPrice,
      'offersOffice': offersOffice,
      'officePrice': officePrice,
      'subscriptionType': subscriptionType,
      'subscriptionStart': subscriptionStart,
      'subscriptionEnd': subscriptionEnd,
    };
  }
}
