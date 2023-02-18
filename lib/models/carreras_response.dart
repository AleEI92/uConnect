
class Carrera {
  final int id;
  final String name;

  const Carrera({
    required this.id,
    required this.name,
  });

  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id: json['id'],
      name: json['name'],
    );
  }
}