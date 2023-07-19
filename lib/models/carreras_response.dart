
import 'dart:convert';

List<Carrera> carrerasFromJson(String str) => List<Carrera>.from(json.decode(str).map((x) => Carrera.fromJson(x)));
String carrerasToJson(List<Carrera> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Carrera {
  Carrera({
    required this.name,
    required this.id,
  });

  String name;
  int id;

  factory Carrera.fromJson(Map<String, dynamic> json) => Carrera(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
