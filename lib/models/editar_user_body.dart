// To parse this JSON data, do
//
//     final editarUserBody = editarUserBodyFromJson(jsonString);

import 'dart:convert';

import 'package:u_connect/models/skill_body.dart';

EditarUserBody editarUserBodyFromJson(String str) => EditarUserBody.fromJson(json.decode(str));

String editarUserBodyToJson(EditarUserBody data) => json.encode(data.toJson());

class EditarUserBody {
  String email;
  String fullName;
  String phoneNumber;
  List<Skill>? skills;
  String career;

  EditarUserBody({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.skills,
    required this.career,
  });

  factory EditarUserBody.fromJson(Map<String, dynamic> json) => EditarUserBody(
    email: json["email"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    skills: json["skills"] != null ? List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))) : null,
    career: json["career"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "skills": skills != null ? List<dynamic>.from(skills!.map((x) => x.toJson())) : null,
    "career": career,
  };
}
