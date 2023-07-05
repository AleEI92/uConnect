
import 'dart:convert';

RegistroUser registroUserFromJson(String str) => RegistroUser.fromJson(json.decode(str));

String registroUserToJson(RegistroUser data) => json.encode(data.toJson());

class RegistroUser {
  RegistroUser({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.career,
  });

  String email;
  String fullName;
  String phoneNumber;
  String password;
  String career;

  factory RegistroUser.fromJson(Map<String, dynamic> json) => RegistroUser(
    email: json["email"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    password: json["password"],
    career: json["career"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "password": password,
    "career": career,
  };
}
