class UserModel {
  final String uid;
  final String email;
  final String phone;
  final String role;
  final String? username;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.phone,
    this.role = "user",
    this.username,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      username: json['username'] ?? "غير معرف",
      fcmToken: json['fcmToken'] ?? "غير معرف",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'role': role,
      'username': username,
      'fcmToken': fcmToken,
    };
  }
}
