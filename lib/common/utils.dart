
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';

import '../custom_widgets/my_awesome_dialog.dart';
import '../models/dialog_body.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Utils {

  late BuildContext context;
  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const SimpleDialog(
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
          ),
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
        btnOkFunction: Utils(context).popDialog,
      ),
    );
  }

  void getFileFromBinaryAndOpen(http.Response response) async {
    List<String>? aux = response.headers['content-disposition']?.split("filename=");
    if (aux != null) {
      String filename = aux.last;
      Uint8List imageInUnit8List = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/$filename').create();
      file.writeAsBytesSync(imageInUnit8List);
      if (file.existsSync()) {
        OpenFile.open('${tempDir.path}/$filename');
      }
    }
    else {
      print("NO SE PUDO RECUPERAR EL NOMBRE ORIGINAL DEL ARCHIVO");
    }
  }
}