import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:u_connect/common/session.dart';
import 'package:u_connect/http/api_provider.dart';
import 'package:u_connect/models/carreras_response.dart';
import 'package:u_connect/models/editar_company_body.dart';
import 'package:u_connect/models/file_upload_response.dart';
import 'package:u_connect/models/generic_post_ok.dart';
import 'package:u_connect/models/company_login_response.dart';
import '../models/oferta_body.dart';
import '../models/student_login_response.dart';


abstract class BaseClient {
  var client = http.Client();

  Future getCarreras();
  Future postRegistrarEstudiante(Object body);
  Future postRegistrarCompanhia(Object body);
  Future postLogin(Object body);
  Future postRecuperarPasswordUser(Object body);
  Future postRecuperarPasswordCompany(Object body);
  Future putChangePassword(Object body, int id, String type);
  Future getCiudades();
  Future postCrearOferta(Object body);
  Future getOfertasByID(int idCompany);
  Future getOfertaByID(int idOferta);
  Future postUploadFile(int id, String type, String typeFile, String file);
  Future putUpdateUser(int id, Object body);
  Future getAllOfertas(int? careerID, String? jobType, List<String>? skills);
  Future getFile(int idOferta);
  Future postApplyToOffer(int idOferta);
  Future getUserByMail(String mail);
  Future deleteJob(int id);
  Future putEditJob(int id, Object body);
}

class MyBaseClient extends BaseClient {
  static const get = "GET";
  static const post = "POST";
  static const bearer = "Bearer ";
  final provider = ApiProvider.getInstance();

  // TOOLS FOR HTTP CALLS
  String _myUT8JsonParser(dynamic val) {
    return const Utf8Decoder().convert(val);
  }

  //////////////////////////////////////////////////////////////////////////
  @override
  Future<List<Carrera>> getCarreras() async {
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
  Future<GenericOkPost> postRecuperarPasswordUser(Object body) async {
    try{
      final response = await provider.post("/user/recover-password/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GenericOkPost> postRecuperarPasswordCompany(Object body) async {
    try{
      final response = await provider.post("/company/recover-password/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future putChangePassword(Object body, int id, String type) async {
    try{
      final response = await provider.put("/change-password/?id=$id&type=$type", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Carrera>> getCiudades() async {
    try{
      final response = await provider.get("/city/all/");
      String json = _myUT8JsonParser(response.bodyBytes);
      return carrerasFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OfertaBody> postCrearOferta(Object body) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.post("/job/create/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return ofertaBodyFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future getOfertasByID(int idCompany) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.get("/job/company-id/$idCompany/");
      String json = _myUT8JsonParser(response.bodyBytes);
      return misOfertasBodyFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future getOfertaByID(int idOferta) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.get("/job/id/$idOferta/");
      String json = _myUT8JsonParser(response.bodyBytes);
      return ofertaBodyFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<FileUploadResponse> postUploadFile(int id, String type, String typeFile, dynamic file) async {
    try{
      provider.fileHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      if (typeFile == "png") {
        provider.fileHeaders['Content-type'] = "image/png";
      }
      else if (typeFile == "jpeg" || typeFile == "jpg") {
        provider.fileHeaders['Content-type'] = "image/jpeg";
      }
      final response = await provider.post("/file/upload/?id=$id&type=$type", file);
      String json = _myUT8JsonParser(response.bodyBytes);
      return fileUploadResponseFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future putUpdateUser(int id, Object body) async {
    Session session = Session.getInstance();
    try{
      // /user/{user_id}/
      provider.baseHeaders['Authorization'] =  bearer + session.userToken;
      if (session.isStudent) {
        final response = await provider.put("/user/$id/", body);
        String str = _myUT8JsonParser(response.bodyBytes);
        return userFromJson(str);
      }
      else {
        final response = await provider.put("/company/$id/", body);
        String str = _myUT8JsonParser(response.bodyBytes);
        return editarEmpresaBodyFromJson(str);
      }
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<OfertaBody>> getAllOfertas(int? careerID, String? jobType, List<String>? skills) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      String urlPATH = "/job/all/";

      if (careerID != null) {
        urlPATH = "$urlPATH?career_id=$careerID";
        if (jobType != null) {
          urlPATH = "$urlPATH&job_type=$jobType";
        }
      }
      else if (jobType != null) {
        urlPATH = "$urlPATH?job_type=$jobType";
      }

      if (skills != null && skills.isNotEmpty) {
        if (careerID != null || jobType != null) {
          urlPATH = "$urlPATH&";
          for (var i = 0; i < skills.length; i++) {
            final value = skills[i];
            urlPATH = "$urlPATH" "skills=$value";
            if (i+1 < skills.length) {
              urlPATH = "$urlPATH&";
            }
          }
        }
        else {
          urlPATH = "$urlPATH?";
          for (var i = 0; i < skills.length; i++) {
            final value = skills[i];
            urlPATH = "$urlPATH" "skills=$value";
            if (i+1 < skills.length) {
              urlPATH = "$urlPATH&";
            }
          }
        }
      }

      dynamic response = await provider.get(urlPATH);
      String json = _myUT8JsonParser(response.bodyBytes);
      return misOfertasBodyFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future getFile(int idOferta) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.get("/file/$idOferta/");
      return response;
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GenericOkPost> postApplyToOffer(int idOferta) async {
    try {
      final response = await provider.post("/job/apply/?job_id=$idOferta", null);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User> getUserByMail(String mail) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.get("/user/email/$mail/");
      String json = _myUT8JsonParser(response.bodyBytes);
      return userFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GenericOkPost> deleteJob(int id) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.delete("/job/$id/");
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GenericOkPost> putEditJob(int id, Object body) async {
    try{
      provider.baseHeaders['Authorization'] =  bearer + Session.getInstance().userToken;
      final response = await provider.put("/job/$id/", body);
      String json = _myUT8JsonParser(response.bodyBytes);
      return genericOkPostFromJson(json);
    }
    catch(e) {
      throw Exception(e.toString());
    }
  }
}