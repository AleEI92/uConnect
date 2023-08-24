
import '../models/carreras_response.dart';

class Constants {
  static const String ipAle = "http://192.168.100.29:8000";
  static const String baseURL = "$ipAle/uconnect/api";

  ////////////////////////////////////////////////////////////////////////
  static const String disculpe = "Disculpe los inconvenientes.";

  static final List<Carrera> listaModalidad = [
    Carrera(name: 'Trabajo', id: 1),
    Carrera(name: 'Pasantía', id: 2)
  ];

  static final List<String> listaExperiencia = [
    "0.5",
    "1",
    "2",
    "3",
    "4",
    "+5"
  ];
}