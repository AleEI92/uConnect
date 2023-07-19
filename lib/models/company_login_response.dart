// To parse this JSON data, do
//
//     final companyLoginResponse = companyLoginResponseFromJson(jsonString);

import 'dart:convert';

CompanyLoginResponse companyLoginResponseFromJson(String str) => CompanyLoginResponse.fromJson(json.decode(str));

String companyLoginResponseToJson(CompanyLoginResponse data) => json.encode(data.toJson());

class CompanyLoginResponse {
  Company company;
  String accessToken;

  CompanyLoginResponse({
    required this.company,
    required this.accessToken,
  });

  factory CompanyLoginResponse.fromJson(Map<String, dynamic> json) => CompanyLoginResponse(
    company: Company.fromJson(json["company"]),
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "company": company.toJson(),
    "access_token": accessToken,
  };
}

class Company {
  int id;
  String email;
  String name;

  Company({
    required this.id,
    required this.email,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    email: json["email"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
  };
}
