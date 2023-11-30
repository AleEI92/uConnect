
import 'package:u_connect/models/company_login_response.dart';
import '../models/carreras_response.dart';
import '../models/skill_body.dart';
import '../models/student_login_response.dart';

class Session {

  static Session? _myInstance;
  String userEmail;
  String userName;
  int userID;
  String userPhoneNumber;
  String userCareer;
  String userToken;
  int? fileId;
  bool isStudent = true;
  late List<Skill>? skills = [];
  late List<Carrera>? allCarreras;
  late List<Carrera>? allCiudades;

  Session([this.userEmail = '',
    this.userName = '',
    this.userID = -1,
    this.userPhoneNumber = '',
    this.userCareer = '',
    this.userToken = '',
    this.fileId,
    this.skills,
    this.allCarreras,
    this.allCiudades
  ]);

  static Session getInstance() {
    _myInstance ??= Session();
    return _myInstance!;
  }

  static void resetInstance() {
    _myInstance = null;
  }

  void setSessionData(dynamic user) {
    if (user is StudentLoginResponse) {
      userEmail = user.user.email != null ? user.user.email! : "";
      userName = user.user.fullName != null ? user.user.fullName! : "";
      userID = user.user.id != null ? user.user.id! : -1;
      userPhoneNumber = user.user.phoneNumber != null ? user.user.phoneNumber! : "";
      userCareer = user.user.careerName != null ? user.user.careerName! : "";
      userToken = user.accessToken;
      fileId = user.user.fileId;
      skills = user.user.skills;
      isStudent = true;
    }
    else {
      userEmail = (user as CompanyLoginResponse).company.email;
      userName = user.company.name;
      userID = user.company.id != null ? user.company.id! : -1;
      userToken = user.accessToken;
      isStudent = false;
    }
  }

  void setCarrerasData(List<Carrera> data) {
    _myInstance?.allCarreras = [];
    _myInstance?.allCarreras!.addAll(data);
  }

  void setCiudadesData(List<Carrera> data) {
    _myInstance?.allCiudades = [];
    _myInstance?.allCiudades!.addAll(data);
  }
}
