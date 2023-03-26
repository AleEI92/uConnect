
import 'dart:convert';

RecoverPasswordBody recoverPasswordBodyFromJson(String str) => RecoverPasswordBody.fromJson(json.decode(str));

String recoverPasswordBodyToJson(RecoverPasswordBody data) => json.encode(data.toJson());

class RecoverPasswordBody {
  RecoverPasswordBody({
    required this.email,
  });

  String email;

  factory RecoverPasswordBody.fromJson(Map<String, dynamic> json) => RecoverPasswordBody(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
