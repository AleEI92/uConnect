

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/common/constants.dart';
import 'package:u_connect/models/recover_pass_body.dart';
import '../common/utils.dart';
import '../http/services.dart';

//ignore: must_be_immutable
class PasswordReset extends StatelessWidget {
  PasswordReset({Key? key}) : super(key: key);

  // KEYS PARA LOS FORMULARIOS
  final _formKey = GlobalKey<FormState>();
  dynamic _mail;
  late BuildContext myCtx;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width *(2/3),
        decoration: BoxDecoration(
          color: Colors.cyan[400],
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  /*const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'INGRESE SU CORREO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold

                      ),
                    ),
                  ),
                  const SizedBox(height: 20),*/
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        return mailValidation(value);
                      },
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 15.0),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_rounded),
                          border: OutlineInputBorder(),
                          labelText: 'Correo',
                          hintText: 'Ingrese correo válido'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                      backgroundColor: MaterialStateProperty.all(Colors.black45),
                    ),
                    child: const Text(
                      'RECUPERAR CONTRASEÑA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Utils(context).startLoading();
                        myCtx = context;
                        callRecoverPassword().then((value) {
                          Utils(context).stopLoading();
                          AwesomeDialog(
                              context: context,
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              dialogType: DialogType.success,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: '¡Solicitud exitosa!',
                              desc:
                                  'Se ha enviado una contraseña de acceso único a su correo.',
                              buttonsTextStyle:
                                  const TextStyle(color: Colors.black),
                              showCloseIcon: false,
                              btnOkText: 'ACEPTAR',
                              btnOkColor: Colors.cyan,
                              btnOkOnPress: Utils(context).popDialog).show();
                        }).onError((error, stackTrace) {
                          Utils(context).stopLoading();
                          Utils(context).showErrorDialog(Constants.disculpe).show();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? mailValidation(String? value) {
    if (value == null || !EmailValidator.validate(value)) {
      _mail = null;
      return 'Ingrese un correo válido.';
    }
    _mail = value.trim();
    return null;
  }

  Future<String> callRecoverPassword() async {
    var body = RecoverPasswordBody(
        email: _mail);

    var response = await MyBaseClient().postRecuperarPassword(recoverPasswordBodyToJson(body));
    return response;
  }

}
