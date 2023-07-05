import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:u_connect/http/api_provider.dart';
import 'package:u_connect/models/carreras_response.dart';
import 'package:u_connect/models/generic_post_ok.dart';
import 'package:u_connect/models/company_login_response.dart';
import 'package:u_connect/models/recover_pass_body.dart';

import '../models/student_login_response.dart';


abstract class BaseClient {
  var client = http.Client();

  Future getCarreras();
  Future postRegistrarEstudiante(Object body);
  Future postLogin(Object body);
  Future postRecuperarPassword(Object body);
}

class MyBaseClient extends BaseClient {
  static const get = "GET";
  static const post = "POST";
  final provider = ApiProvider();

  // TOOLS FOR HTTP CALLS
  String _myUT8JsonParser(dynamic val) {
    return const Utf8Decoder().convert(val);
  }

  //////////////////////////////////////////////////////////////////////////
  @override
  Future getCarreras() async {
    try {
      final response = await provider.get("/career/all/");
      String json = _myUT8JsonParser(response.bodyBytes);
      return carrerasFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future postRegistrarEstudiante(Object body) async {
    try {
      final response = await provider.post("/user/create/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future postRegistrarCompanhia(Object body) async {
    try {
      final response = await provider.post("/company/create/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future postLogin(Object body) async {
    try{
      final response = await provider.post("/login/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      if (json.contains("company")) {
        return companyLoginResponseFromJson(json);
      }
      else {
        return studentLoginResponseFromJson(json);
      }
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future postRecuperarPassword(Object body) async {
    try{
      final response = await provider.post("/user/recover-password/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return recoverPasswordBodyFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }
}