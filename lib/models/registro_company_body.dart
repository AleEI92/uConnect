
import 'dart:convert';

RegistroCompany registroCompanyFromJson(String str) => RegistroCompany.fromJson(json.decode(str));

String registroCompanyToJson(RegistroCompany data) => json.encode(data.toJson());

class RegistroCompany {
  RegistroCompany({
    required this.email,
    required this.name,
    required this.password,
  });

  String email;
  String name;
  String password;

  factory RegistroCompany.fromJson(Map<String, dynamic> json) => RegistroCompany(
    email: json["email"],
    name: json["name"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
    "password": password,
  };
}
