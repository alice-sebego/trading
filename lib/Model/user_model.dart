class UserModel {
  final String uid;
  final String email;
  final String? username;
  final String? phone;
  final String? country;

  UserModel({
    required this.uid,
    required this.email,
    this.username,
    this.phone,
    this.country,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'],
      phone: map['phone'],
      country: map['country'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'phone': phone,
      'country': country,
    };
  }
}
