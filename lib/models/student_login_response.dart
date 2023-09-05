// To parse this JSON data, do
//
//     final studentLoginResponse = studentLoginResponseFromJson(jsonString);

import 'dart:convert';

StudentLoginResponse studentLoginResponseFromJson(String str) => StudentLoginResponse.fromJson(json.decode(str));

String studentLoginResponseToJson(StudentLoginResponse data) => json.encode(data.toJson());

class StudentLoginResponse {
  User user;
  String accessToken;

  StudentLoginResponse({
    required this.user,
    required this.accessToken,
  });

  factory StudentLoginResponse.fromJson(Map<String, dynamic> json) => StudentLoginResponse(
    user: User.fromJson(json["user"]),
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "access_token": accessToken,
  };
}

class User {
  String? email;
  String? fullName;
  int? id;
  String? phoneNumber;
  String? careerName;
  int? fileId;

  User({
    required this.email,
    required this.fullName,
    required this.id,
    required this.phoneNumber,
    required this.careerName,
    this.fileId
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    fullName: json["full_name"],
    id: json["id"],
    phoneNumber: json["phone_number"],
    careerName: json["career_name"],
    fileId: json["file_id"]
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "id": id,
    "phone_number": phoneNumber,
    "career_name": careerName,
    "file_id": fileId,
  };
}
