import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/dialog_body.dart';

AwesomeDialog myAwesomeDialog(BuildContext context, DialogBody body) {
  return AwesomeDialog(
      context: context,
      autoDismiss: false,
      onDismissCallback: (type) {},
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      headerAnimationLoop: false,
      showCloseIcon: false,
      dialogType: body.type,
      animType: AnimType.rightSlide,
      buttonsTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      btnOkColor: Colors.cyan[400],
      btnCancelColor: Colors.grey[400],
      title: body.title,
      desc: body.desc,
      btnOkText: body.btnOkText,
      btnOkOnPress: () => body.btnOkFunction(),
      btnCancelText: body.btnCancelText,
      btnCancelOnPress: check(body));
}

VoidCallback? check(DialogBody body) {
  if (body.showCancelBtn) {
    return body.btnCancelFunction!;
  }
  else {
    return null;
  }
}
