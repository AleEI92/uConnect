


import 'package:u_connect/models/company_login_response.dart';

import '../models/student_login_response.dart';

class Session {

  static Session? _myInstance;
  String userEmail;
  String userName;
  int userID;
  String userPhoneNumber;
  String userCareer;
  String userToken;

  Session([this.userEmail = '',
    this.userName = '',
    this.userID = -1,
    this.userPhoneNumber = '',
    this.userCareer = '',
    this.userToken = ''
  ]);

  static Session getInstance() {
    _myInstance ??= Session();
    return _myInstance!;
  }

  void setSessionData(dynamic user) {
    if (user is StudentLoginResponse) {
      userEmail = user.user.email;
      userName = user.user.fullName;
      userID = user.user.id;
      userPhoneNumber = user.user.phoneNumber;
      userCareer = user.user.careerName;
      userToken = user.accessToken;
    }
    else {
      userEmail = (user as CompanyLoginResponse).company.email;
      userName = user.company.name;
      userID = user.company.id;
      userToken = user.accessToken;
    }
  }
}
