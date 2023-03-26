
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogBody {
  DialogBody({
    required this.type,
    required this.title,
    required this.desc,
    required this.btnOkText,
    required this.btnOkFunction,
    this.showCancelBtn = false,
    this.btnCancelText,
    this.btnCancelFunction,
  });

  DialogType type;
  String title;
  String desc;
  String btnOkText;
  VoidCallback btnOkFunction;
  bool showCancelBtn;
  String? btnCancelText;
  VoidCallback? btnCancelFunction;
}