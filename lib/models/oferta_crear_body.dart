// To parse this JSON data, do
//
//     final oferta = ofertaFromJson(jsonString);

import 'dart:convert';

import 'package:u_connect/models/skill_body.dart';

CrearOfertaBody ofertaFromJson(String str) => CrearOfertaBody.fromJson(json.decode(str));

String ofertaToJson(CrearOfertaBody data) => json.encode(data.toJson());

class CrearOfertaBody {
  String description;
  String jobType;
  String career;
  String city;
  int? companyId;
  String? file;
  List<Skill> skills;

  CrearOfertaBody({
    required this.description,
    required this.jobType,
    required this.career,
    required this.city,
    this.companyId,
    this.file,
    required this.skills,
  });

  factory CrearOfertaBody.fromJson(Map<String, dynamic> json) => CrearOfertaBody(
    description: json["description"],
    jobType: json["job_type"],
    career: json["career"],
    city: json["city"],
    companyId: json["company_id"],
    file: json["file"],
    skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "job_type": jobType,
    "career": career,
    "city": city,
    "company_id": companyId,
    "file": file,
    "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
  };
}
