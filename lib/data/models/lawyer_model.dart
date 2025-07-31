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
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime(
              (json['dateOfBirth'] as Timestamp).toDate().year,
              (json['dateOfBirth'] as Timestamp).toDate().month,
              (json['dateOfBirth'] as Timestamp).toDate().day,
            )
          : null,
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      registrationNumber: json['registrationNumber'],
      registrationDate: json['registrationDate'] != null
          ? DateTime(
              (json['registrationDate'] as Timestamp).toDate().year,
              (json['registrationDate'] as Timestamp).toDate().month,
              (json['registrationDate'] as Timestamp).toDate().day,
            )
          : null,
      specialty: List<String>.from(json['specialty'] ?? []),
      cardImageUrl: json['cardImageUrl'],
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
      availableAppointments: json['availableAppointments'] != null
          ? List<DateTime>.from(
              (json['availableAppointments'] as List<dynamic>).map(
                (e) => (e as Timestamp).toDate(),
              ),
            )
          : [],
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
      'offersCall': offersCall,
      'callPrice': callPrice,
      'offersOffice': offersOffice,
      'officePrice': officePrice,
      'subscriptionType': subscriptionType,
      'subscriptionStart': subscriptionStart,
      'subscriptionEnd': subscriptionEnd,
      'availableAppointments': availableAppointments,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};

    if (email.isNotEmpty) data['email'] = email;
    if (phone.isNotEmpty) data['phone'] = phone;
    if (gender != null) data['gender'] = gender;
    if (governorate != null) data['governorate'] = governorate;
    if (fullName != null) data['fullName'] = fullName;
    if (nationalId != null) data['nationalId'] = nationalId;
    if (address != null) data['address'] = address;

    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth;
    }

    if (profilePictureUrl != null) {
      data['profilePictureUrl'] = profilePictureUrl;
    }
    if (bio != null) data['bio'] = bio;
    if (registrationNumber != null) {
      data['registrationNumber'] = registrationNumber;
    }

    if (registrationDate != null) {
      data['registrationDate'] = registrationDate;
    }

    if (specialty != null) data['specialty'] = specialty;
    if (cardImageUrl != null) data['cardImageUrl'] = cardImageUrl;

    if (offersCall != null) data['offersCall'] = offersCall;
    if (callPrice != null) data['callPrice'] = callPrice;
    if (offersOffice != null) data['offersOffice'] = offersOffice;
    if (officePrice != null) data['officePrice'] = officePrice;

    data['subscriptionType'] = subscriptionType;
    if (subscriptionStart != null) {
      data['subscriptionStart'] = subscriptionStart;
    }
    if (subscriptionEnd != null) {
      data['subscriptionEnd'] = subscriptionEnd;
    }

    data['status'] = status;
    if (availableAppointments.isNotEmpty) {
      data['availableAppointments'] = availableAppointments;
    }

    return data;
  }

  LawyerModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? role,
    String? status,
    List<String>? rejectionReasons,
    String? fullName,
    String? nationalId,
    String? governorate,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? profilePictureUrl,
    String? bio,
    String? registrationNumber,
    DateTime? registrationDate,
    List<String>? specialty,
    String? cardImageUrl,
    bool? offersCall,
    double? callPrice,
    bool? offersOffice,
    double? officePrice,
    String? subscriptionType,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    List<DateTime>? availableAppointments,
  }) {
    return LawyerModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      rejectionReasons: rejectionReasons ?? this.rejectionReasons,
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      governorate: governorate ?? this.governorate,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      registrationDate: registrationDate ?? this.registrationDate,
      specialty: specialty ?? this.specialty,
      cardImageUrl: cardImageUrl ?? this.cardImageUrl,
      offersCall: offersCall ?? this.offersCall,
      callPrice: callPrice ?? this.callPrice,
      offersOffice: offersOffice ?? this.offersOffice,
      officePrice: officePrice ?? this.officePrice,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      availableAppointments:
          availableAppointments ?? this.availableAppointments,
    );
  }
}
