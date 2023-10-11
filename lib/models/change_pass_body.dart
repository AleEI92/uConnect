
import 'dart:convert';

ChangePasswordBody changePasswordBodyFromJson(String str) => ChangePasswordBody.fromJson(json.decode(str));

String changePasswordBodyToJson(ChangePasswordBody data) => json.encode(data.toJson());

class ChangePasswordBody {
  String oldPassword;
  String newPassword;

  ChangePasswordBody({
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePasswordBody.fromJson(Map<String, dynamic> json) => ChangePasswordBody(
    oldPassword: json["old_password"],
    newPassword: json["new_password"],
  );

  Map<String, dynamic> toJson() => {
    "old_password": oldPassword,
    "new_password": newPassword,
  };
}
