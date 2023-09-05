// To parse this JSON data, do
//
//     final myFile = myFileFromJson(jsonString);

import 'dart:convert';

MyFile myFileFromJson(String str) => MyFile.fromJson(json.decode(str));

String myFileToJson(MyFile data) => json.encode(data.toJson());

class MyFile {
  String file;

  MyFile({
    required this.file,
  });

  factory MyFile.fromJson(Map<String, dynamic> json) => MyFile(
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "file": file,
  };
}
