// To parse this JSON data, do
//
//     final ofertaBody = ofertaBodyFromJson(jsonString);

import 'dart:convert';

import 'package:u_connect/models/skill_body.dart';
import 'package:u_connect/models/student_login_response.dart';

OfertaBody ofertaBodyFromJson(String str) => OfertaBody.fromJson(json.decode(str));

String ofertaBodyToJson(OfertaBody data) => json.encode(data.toJson());

List<OfertaBody> misOfertasBodyFromJson(String str) => List<OfertaBody>.from(json.decode(str).map((x) => OfertaBody.fromJson(x)));

String misOfertasBodyToJson(List<OfertaBody> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfertaBody {
  int? id;
  String? description;
  String? jobType;
  String? careerName;
  String? cityName;
  String? companyName;
  bool? active;
  int? fileId;
  DateTime? creationDate;
  List<Skill>? skills;
  List<User>? users;

  OfertaBody({
    this.id,
    this.description,
    this.jobType,
    this.careerName,
    this.cityName,
    this.companyName,
    this.active,
    this.fileId,
    this.creationDate,
    this.skills,
    required this.users,
  });

  factory OfertaBody.fromJson(Map<String, dynamic> json) => OfertaBody(
    id: json["id"],
    description: json["description"],
    jobType: json["job_type"],
    careerName: json["career_name"],
    cityName: json["city_name"],
    companyName: json["company_name"],
    active: json["active"],
    fileId: json["file_id"],
    creationDate: DateTime.parse(json["creation_date"]),
    skills: json["skills"] != null ? List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))) : null,
    users: json["users"] != null ? List<User>.from(json["users"].map((x) => User.fromJson(x))) : null
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "job_type": jobType,
    "career_name": careerName,
    "city_name": cityName,
    "company_name": companyName,
    "active": active,
    "file_id": fileId,
    "creation_date": "${creationDate?.year.toString().padLeft(4, '0')}-${creationDate?.month.toString().padLeft(2, '0')}-${creationDate?.day.toString().padLeft(2, '0')}",
    "skills": skills != null ? List<dynamic>.from(skills!.map((x) => x.toJson())) : null,
    "users": users != null ? List<dynamic>.from(users!.map((x) => x.toJson())) : null,
  };
}
