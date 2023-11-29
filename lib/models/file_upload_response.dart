// To parse this JSON data, do
//
//     final fileUploadResponse = fileUploadResponseFromJson(jsonString);

import 'dart:convert';

FileUploadResponse fileUploadResponseFromJson(String str) => FileUploadResponse.fromJson(json.decode(str));

String fileUploadResponseToJson(FileUploadResponse data) => json.encode(data.toJson());

class FileUploadResponse {
  int fileId;

  FileUploadResponse({
    required this.fileId,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) => FileUploadResponse(
    fileId: json["file_id"],
  );

  Map<String, dynamic> toJson() => {
    "file_id": fileId,
  };
}
