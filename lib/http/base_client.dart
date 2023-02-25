import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:u_connect/http/api_provider.dart';
import 'package:u_connect/models/carreras_response.dart';
import 'package:u_connect/models/generic_post_ok.dart';
import 'package:u_connect/models/login_response.dart';

abstract class BaseClient {
  var client = http.Client();
  final ApiProvider _provider = ApiProvider();

  Future getCarreras();
  Future postRegistrar(Object body);
  Future postLogin(Object body);
  Future postRecuperarPassword();
}

class MyBaseClient extends BaseClient {
  static const get = "GET";
  static const post = "POST";

  // TOOLS FOR HTTP CALLS
  String _myUT8JsonParser(dynamic val) {
    return const Utf8Decoder().convert(val);
  }

  //////////////////////////////////////////////////////////////////////////
  @override
  Future getCarreras() async {
    final response = await _provider.get("/career/all/");
    String json = _myUT8JsonParser(response.bodyBytes);
    return carrerasFromJson(json);
  }

  @override
  Future postRegistrar(Object body) async {
    final response = await _provider.post("/users/create/", body);
    String json = _myUT8JsonParser(response.bodyBytes);
    return genericOkPostFromJson(json);
  }

  @override
  Future postLogin(Object body) async {
    final response = await _provider.post("/login/", body);
    String json = _myUT8JsonParser(response.bodyBytes);
    return loginResponseFromJson(json);
  }

  @override
  Future postRecuperarPassword() {
    throw UnimplementedError();
  }
}