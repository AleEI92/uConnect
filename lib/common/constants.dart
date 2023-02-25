
class Constants {

  static const String ip = "http://192.168.100.159:8000";

  static const String baseURL = "$ip/uconnect/api";

  static const Map<String, String> baseHeaders = {
    'Content-type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

}