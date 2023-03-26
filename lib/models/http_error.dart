
// To parse this JSON data, do
//
//     final httpError = httpErrorFromJson(jsonString);

import 'dart:convert';

HttpError httpErrorFromJson(String str) => HttpError.fromJson(json.decode(str));

String httpErrorToJson(HttpError data) => json.encode(data.toJson());

class HttpError {
  HttpError({
    required this.detail,
  });

  String detail;

  factory HttpError.fromJson(Map<String, dynamic> json) => HttpError(
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
  };
}
