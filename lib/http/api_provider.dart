

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:u_connect/common/constants.dart';
import 'dart:io';
import 'dart:async';
import 'custom_exceptions.dart';

class ApiProvider {
  final String _baseUrl = Constants.baseURL;

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Object body) async {
    var responseJson;
    try {
      //encode Map to JSON
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: body, headers: Constants.baseHeaders);
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
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
