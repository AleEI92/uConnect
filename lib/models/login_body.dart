
import 'dart:convert';

LoginBody loginBodyFromJson(String str) => LoginBody.fromJson(json.decode(str));

String loginBodyToJson(LoginBody data) => json.encode(data.toJson());

class LoginBody {
  LoginBody({
    required this.username,
    required this.password,
  });

  String username;
  String password;

  factory LoginBody.fromJson(Map<String, dynamic> json) => LoginBody(
    username: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };
}
