
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  User user;
  String accessToken;
  String tokenType;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    user: User.fromJson(json["user"]),
    accessToken: json["access_token"],
    tokenType: json["token_type"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "access_token": accessToken,
    "token_type": tokenType,
  };
}

class User {
  User({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.id,
    required this.careerId,
  });

  String email;
  String fullName;
  String phoneNumber;
  int id;
  int careerId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    id: json["id"],
    careerId: json["career_id"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "id": id,
    "career_id": careerId,
  };
}
