// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String? name;
  final String? inviteCode;
  final List<String> roles;
  final String? phoneNumber;
  final String? email;
  final bool profileFill;

  UserModel({
    required this.name,
    required this.inviteCode,
    required this.roles,
    required this.phoneNumber,
    required this.email,
    required this.profileFill,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'inviteCode': inviteCode,
      'roles': roles,
      'phoneNumber': phoneNumber,
      'email': email,
      'profileFill': profileFill,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String?,
      inviteCode: map['inviteCode'] as String?,
      roles: List<String>.from((map['roles'] ?? [])),
      phoneNumber: map['phoneNumber'] as String?,
      email: map['email'] as String?,
      profileFill: (map['profileFill'] as bool?) ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'UserModel(name: $name, inviteCode: $inviteCode, roles: $roles, phoneNumber: $phoneNumber, email: $email, profileFill: $profileFill)';
  }
}
