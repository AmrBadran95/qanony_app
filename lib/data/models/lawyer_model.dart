// class LawyerModel {
//   final String name;
//   final String type;
//   final List<String> specialization;
//   final String contactMethod;
//   final int YearsOfExperience;
//   final double? sessionPrice;

//   LawyerModel({
//     required this.name,
//     required this.type,
//     required this.specialization,
//     required this.contactMethod,
//     required this.YearsOfExperience,
//     required this.sessionPrice,
//   });
// }

class LawyerModel {
  final String uid;
  final String email;
  final String phone;
  final String role;
  final String status;

  final String? fullName;
  final String? nationalId;
  final String? governorate;
  final String? address;
  final String? dateOfBirth;
  final String? gender;
  final String? profilePictureUrl;

  final String? bio;
  final String? registrationNumber;
  final String? registrationDate;
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

  LawyerModel({
    required this.uid,
    required this.email,
    required this.phone,
    this.role = 'lawyer',
    this.status = 'pending',
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
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      uid: json['uid'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
      fullName: json['fullName'],
      nationalId: json['nationalId'],
      governorate: json['governorate'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      registrationNumber: json['registrationNumber'],
      registrationDate: json['registrationDate'],
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
          ? DateTime.parse(json['subscriptionStart'])
          : null,
      subscriptionEnd: json['subscriptionEnd'] != null
          ? DateTime.parse(json['subscriptionEnd'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
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
      'subscriptionStart': subscriptionStart?.toIso8601String(),
      'subscriptionEnd': subscriptionEnd?.toIso8601String(),
    };
  }
}
