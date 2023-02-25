
import 'dart:convert';

GenericOkPost genericOkPostFromJson(String str) => GenericOkPost.fromJson(json.decode(str));

String genericOkPostToJson(GenericOkPost data) => json.encode(data.toJson());

class GenericOkPost {
  GenericOkPost({
    required this.message,
  });

  String message;

  factory GenericOkPost.fromJson(Map<String, dynamic> json) => GenericOkPost(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
