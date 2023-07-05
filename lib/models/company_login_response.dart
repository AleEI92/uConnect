// To parse this JSON data, do
//
//     final companyLoginResponse = companyLoginResponseFromJson(jsonString);

import 'dart:convert';

CompanyLoginResponse companyLoginResponseFromJson(String str) => CompanyLoginResponse.fromJson(json.decode(str));

String companyLoginResponseToJson(CompanyLoginResponse data) => json.encode(data.toJson());

class CompanyLoginResponse {
  Company company;
  String accessToken;
  String tokenType;

  CompanyLoginResponse({
    required this.company,
    required this.accessToken,
    required this.tokenType,
  });

  factory CompanyLoginResponse.fromJson(Map<String, dynamic> json) => CompanyLoginResponse(
    company: Company.fromJson(json["company"]),
    accessToken: json["access_token"],
    tokenType: json["token_type"],
  );

  Map<String, dynamic> toJson() => {
    "company": company.toJson(),
    "access_token": accessToken,
    "token_type": tokenType,
  };
}

class Company {
  String password;
  dynamic passwordResetCode;
  int id;
  String email;
  String name;

  Company({
    required this.password,
    this.passwordResetCode,
    required this.id,
    required this.email,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    password: json["password"],
    passwordResetCode: json["password_reset_code"],
    id: json["id"],
    email: json["email"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "password": password,
    "password_reset_code": passwordResetCode,
    "id": id,
    "email": email,
    "name": name,
  };
}
