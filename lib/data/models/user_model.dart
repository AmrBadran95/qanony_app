class UserModel {
  final String uid;
  final String email;
  final String phone;
  final String? username;

  UserModel({
    required this.uid,
    required this.email,
    required this.phone,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'] ?? "غير معرف",
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'phone': phone, 'username': username};
  }
}
