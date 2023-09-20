// To parse this JSON data, do
//
//     final editarEmpresaBody = editarEmpresaBodyFromJson(jsonString);

import 'dart:convert';

EditarEmpresaBody editarEmpresaBodyFromJson(String str) => EditarEmpresaBody.fromJson(json.decode(str));

String editarEmpresaBodyToJson(EditarEmpresaBody data) => json.encode(data.toJson());

class EditarEmpresaBody {
  String email;
  String name;

  EditarEmpresaBody({
    required this.email,
    required this.name,
  });

  factory EditarEmpresaBody.fromJson(Map<String, dynamic> json) => EditarEmpresaBody(
    email: json["email"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
  };
}
