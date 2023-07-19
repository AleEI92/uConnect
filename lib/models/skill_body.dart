// To parse this JSON data, do
//
//     final skill = skillFromJson(jsonString);

import 'dart:convert';

Skill skillFromJson(String str) => Skill.fromJson(json.decode(str));

String skillToJson(Skill data) => json.encode(data.toJson());

class Skill {
  String skillName;
  String experience;

  Skill({
    required this.skillName,
    required this.experience,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    skillName: json["skill_name"],
    experience: json["experience"],
  );

  Map<String, dynamic> toJson() => {
    "skill_name": skillName,
    "experience": experience,
  };
}
