
import 'dart:convert';

List<Carreras> carrerasFromJson(String str) => List<Carreras>.from(json.decode(str).map((x) => Carreras.fromJson(x)));
String carrerasToJson(List<Carreras> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Carreras {
  Carreras({
    required this.name,
    required this.id,
  });

  String name;
  int id;

  factory Carreras.fromJson(Map<String, dynamic> json) => Carreras(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
