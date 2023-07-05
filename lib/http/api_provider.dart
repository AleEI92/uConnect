
import 'package:http/http.dart' as http;
import 'package:u_connect/common/constants.dart';
import 'dart:io';
import 'custom_exceptions.dart';

class ApiProvider {

  final String _baseUrl = Constants.baseURL;
  final Duration myTimeout = const Duration(seconds: 30);

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    try {
      print("GET: ${(_baseUrl + url)}");
      final response = await http.get(Uri.parse(_baseUrl + url)).timeout(myTimeout);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Object body) async {
    dynamic responseJson;
    try {
      print("POST: ${(_baseUrl + url)}");
      dynamic response;
      if (url.contains("login")) {
        response = await http.post(Uri.parse(_baseUrl + url),
            body: body, headers: Constants.loginHeaders).timeout(myTimeout);
      }
      else {
        response = await http.post(Uri.parse(_baseUrl + url),
            body: body, headers: Constants.baseHeaders).timeout(myTimeout);
      }
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return response;

      case 400:
        print(response.body);
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        print(response.body);
        throw UnauthorisedException(response.body.toString());

      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
