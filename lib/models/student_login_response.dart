// To parse this JSON data, do
//
//     final studentLoginResponse = studentLoginResponseFromJson(jsonString);

import 'dart:convert';

StudentLoginResponse studentLoginResponseFromJson(String str) => StudentLoginResponse.fromJson(json.decode(str));

String studentLoginResponseToJson(StudentLoginResponse data) => json.encode(data.toJson());

class StudentLoginResponse {
  User user;
  String accessToken;
  String tokenType;

  StudentLoginResponse({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  factory StudentLoginResponse.fromJson(Map<String, dynamic> json) => StudentLoginResponse(
    user: User.fromJson(json["user"]),
    accessToken: json["access_token"],
    tokenType: json["token_type"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "access_token": accessToken,
    "token_type": tokenType,
  };
}

class User {
  String email;
  String fullName;
  dynamic passwordResetCode;
  dynamic fileId;
  String password;
  int id;
  String phoneNumber;
  int careerId;
  Career career;
  dynamic file;

  User({
    required this.email,
    required this.fullName,
    this.passwordResetCode,
    this.fileId,
    required this.password,
    required this.id,
    required this.phoneNumber,
    required this.careerId,
    required this.career,
    this.file,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    fullName: json["full_name"],
    passwordResetCode: json["password_reset_code"],
    fileId: json["file_id"],
    password: json["password"],
    id: json["id"],
    phoneNumber: json["phone_number"],
    careerId: json["career_id"],
    career: Career.fromJson(json["career"]),
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "password_reset_code": passwordResetCode,
    "file_id": fileId,
    "password": password,
    "id": id,
    "phone_number": phoneNumber,
    "career_id": careerId,
    "career": career.toJson(),
    "file": file,
  };
}

class Career {
  int id;
  String name;

  Career({
    required this.id,
    required this.name,
  });

  factory Career.fromJson(Map<String, dynamic> json) => Career(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
