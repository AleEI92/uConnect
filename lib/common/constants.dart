
import '../models/carreras_response.dart';

class Constants {
  static const String localIP = "http://192.168.100.22";
  //static const String publicIP = "http://34.196.114.158";
  static const String baseURL = "$localIP/uconnect/api";

  ////////////////////////////////////////////////////////////////////////
  static const String disculpe = "Disculpe los inconvenientes.";

  // JMMG01@HOTMAIL.COM

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

  static const String job = "job";
  static const String user = "user";
  static const String company = "company";
}