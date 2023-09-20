// To parse this JSON data, do
//
//     final studentLoginResponse = studentLoginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:u_connect/models/skill_body.dart';

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

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? email;
  String? fullName;
  int? id;
  String? phoneNumber;
  String? careerName;
  int? fileId;
  List<Skill>? skills;

  User({
    required this.email,
    required this.fullName,
    required this.id,
    required this.phoneNumber,
    required this.careerName,
    this.fileId,
    this.skills
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    fullName: json["full_name"],
    id: json["id"],
    phoneNumber: json["phone_number"],
    careerName: json["career_name"],
    fileId: json["file_id"],
    skills: json["skills"] != null ? List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "id": id,
    "phone_number": phoneNumber,
    "career_name": careerName,
    "file_id": fileId,
    "skills": skills != null ? List<dynamic>.from(skills!.map((x) => x.toJson())) : null,
  };
}
