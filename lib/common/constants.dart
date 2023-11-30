
import '../models/carreras_response.dart';

class Constants {
  //static const String localIP = "http://192.168.100.29";
  static const String awsIP = "http://34.196.114.158";
  static const String baseURL = "$awsIP/uconnect/api";

  ////////////////////////////////////////////////////////////////////////
  static const String disculpe = "Disculpe los inconvenientes";
  static const String versionCode = "1.1.0";

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