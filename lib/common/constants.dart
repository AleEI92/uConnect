
class Constants {

  static const String ipKinzu = "http://192.168.100.159:8000";
  static const String ipAle = "http://192.168.0.30:8000";
  static const String disculpe = "Disculpe los inconvenientes.";

  static const String baseURL = "$ipAle/uconnect/api";

  static const Map<String, String> baseHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, String> loginHeaders = {
    'Content-type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

}