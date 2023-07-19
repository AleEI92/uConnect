
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../custom_widgets/my_awesome_dialog.dart';
import '../models/dialog_body.dart';

class Utils {

  late BuildContext context;

  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: SpinKitRipple(
                color: Colors.cyan,
                size: 90.0,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  void popDialog() {
    Navigator.of(context).pop(true);
  }

  AwesomeDialog showErrorDialog(String desc) {
    return myAwesomeDialog(
      context,
      DialogBody(
        type: DialogType.error,
        title: 'Oops.. Algo ha ocurrido',
        desc: desc,
        btnOkText: 'ACEPTAR',
        //btnOkFunction: ,
        btnOkFunction: Utils(context).popDialog,
      ),
    );
  }

  /*Future<void> storeUserData(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.estudiante, true);
    prefs.setString("userData", userData);
    if (userData.contains("company")) {
      prefs.setBool(Constants.estudiante, false);
    }
  }

  Future<dynamic> retrieveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? temp = prefs.getString("userData");

    if (temp != null) {
      if (temp.contains("company")) {
        return companyLoginResponseFromJson(temp);
      }
      else {
        return studentLoginResponseFromJson(temp);
      }
    }
    else {
      return null;
    }
  }

  Future<bool> userIsStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.estudiante) ?? true;
  }*/
}