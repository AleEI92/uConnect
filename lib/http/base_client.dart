import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:u_connect/models/carreras_response.dart';

const String baseUrl = 'http://192.168.100.159:8000/uconnect/api';
const Map<String, String> myHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

abstract class BaseClient {
  var client = http.Client();
  Future getCarreras();
}

class MyBaseClient extends BaseClient {

  dynamic res;

  @override
  Future<dynamic> getCarreras() async {
    var url = Uri.parse('$baseUrl/career/');
    var response = await client.get(url, headers: myHeaders).timeout(const Duration(seconds: 30));

    if (handleResponse(response) != null) {
      List<String> listCarreras = [];
      for (int i=0; i<(res as List<dynamic>).length; i++) {
        var elemento = Carrera.fromJson((res as List<dynamic>)[i]);
        listCarreras.add(elemento.name);
      }
      print(listCarreras);
      return listCarreras;
    }
    else { // CASO DE ERROR!
      print('ERROR CODE: ${response.statusCode}');
      return Exception('Algo ha fallado!');
    }
  }

  // TOOLS FOR HTTP CALLS
  dynamic handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      res = _myJsonParser(response.bodyBytes);
      return res;
    }
    else {
      res = null;
      return res;
    }
  }

  dynamic _myJsonParser(Uint8List val) {
    return json.decode(utf8.decode(val));
  }
}