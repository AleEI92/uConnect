// To parse this JSON data, do
//
//     final ofertaBody = ofertaBodyFromJson(jsonString);

import 'dart:convert';

import 'package:u_connect/models/skill_body.dart';

OfertaBody ofertaBodyFromJson(String str) => OfertaBody.fromJson(json.decode(str));

String ofertaBodyToJson(OfertaBody data) => json.encode(data.toJson());

class OfertaBody {
  int? id;
  String? description;
  String? jobType;
  String? careerName;
  String? cityName;
  int? companyId;
  bool? active;
  int? fileId;
  DateTime? creationDate;
  List<Skill>? skills;

  OfertaBody({
    this.id,
    this.description,
    this.jobType,
    this.careerName,
    this.cityName,
    this.companyId,
    this.active,
    this.fileId,
    this.creationDate,
    this.skills,
  });

  factory OfertaBody.fromJson(Map<String, dynamic> json) => OfertaBody(
    id: json["id"],
    description: json["description"],
    jobType: json["job_type"],
    careerName: json["career_name"],
    cityName: json["city_name"],
    companyId: json["company_id"],
    active: json["active"],
    fileId: json["file_id"],
    creationDate: DateTime.parse(json["creation_date"]),
    skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "job_type": jobType,
    "career_name": careerName,
    "city_name": cityName,
    "company_id": companyId,
    "active": active,
    "file_id": fileId,
    "creation_date": "${creationDate?.year.toString().padLeft(4, '0')}-${creationDate?.month.toString().padLeft(2, '0')}-${creationDate?.day.toString().padLeft(2, '0')}",
    "skills": List<dynamic>.from(skills!.map((x) => x.toJson())),
  };
}
