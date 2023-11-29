
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/common/constants.dart';
import 'package:u_connect/common/session.dart';
import 'package:u_connect/models/change_pass_body.dart';
import 'package:u_connect/models/generic_post_ok.dart';
import 'package:u_connect/models/recover_pass_body.dart';
import '../common/utils.dart';
import '../http/services.dart';
import 'login.dart';


//ignore: must_be_immutable
class PasswordChangeReset extends StatelessWidget {
  final bool isRecovering;
  PasswordChangeReset({Key? key, required this.isRecovering}) : super(key: key);

  // KEYS PARA LOS FORMULARIOS
  final _formKey = GlobalKey<FormState>();
  final _oldPassKey = TextEditingController();
  final _newPassKey = TextEditingController();
  String mensaje = "CAMBIAR CONTRASEÑA";
  dynamic _mail;

  @override
  Widget build(BuildContext context) {
    if (isRecovering) {
      mensaje = "RECUPERAR CONTRASEÑA";
    }
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
                icon: const Icon(Icons.close_rounded, size: 24),
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
                  isRecovering ?
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
                            labelText: 'Correo'),
                      ),
                    ) :
                    Column(
                      children: [
                        TextFormField(
                          controller: _oldPassKey,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo no puede estar vacío.';
                            }
                            return null;
                          },
                          maxLines: 1,
                          maxLength: 16,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: const TextStyle(fontSize: 15.0),
                          decoration: const InputDecoration(
                              counterText: '',
                              prefixIcon: Icon(Icons.key_rounded),
                              border: OutlineInputBorder(),
                              labelText: 'Vieja contraseña'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _newPassKey,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo no puede estar vacío.';
                            }
                            return null;
                          },
                          maxLines: 1,
                          maxLength: 16,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: const TextStyle(fontSize: 15.0),
                          decoration: const InputDecoration(
                              counterText: '',
                              prefixIcon: Icon(Icons.key_rounded),
                              border: OutlineInputBorder(),
                              labelText: 'Nueva contraseña'),
                        ),
                      ]
                    ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                      backgroundColor: MaterialStateProperty.all(Colors.black45),
                    ),
                    child: Text(
                      mensaje,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (isRecovering) {
                        if (_formKey.currentState!.validate()) {
                          Utils(context).startLoading();
                          callRecoverPasswordUser().then((value) {
                            Utils(context).stopLoading();
                            AwesomeDialog(
                                context: context,
                                dismissOnTouchOutside: false,
                                dismissOnBackKeyPress: false,
                                dialogType: DialogType.success,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                title: '¡Solicitud exitosa!',
                                desc: value.message,
                                buttonsTextStyle:
                                const TextStyle(color: Colors.black),
                                showCloseIcon: false,
                                btnOkText: 'ACEPTAR',
                                btnOkColor: Colors.cyan,
                                btnOkOnPress: Utils(context).popDialog).show();
                          }).onError((error, stackTrace) {
                            if (error is Exception) {
                              if (error.toString().contains("El correo no se encuentra registrado")) {
                                callRecoverPasswordCompany().then((value) {
                                  Utils(context).stopLoading();
                                  AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.success,
                                      headerAnimationLoop: false,
                                      animType: AnimType.bottomSlide,
                                      title: '¡Solicitud exitosa!',
                                      desc: value.message,
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
                              else {
                                Utils(context).stopLoading();
                                Utils(context).showErrorDialog(Constants.disculpe).show();
                              }
                            }
                          });
                        }
                      }
                      else {
                        Utils(context).startLoading();
                        callChangePassword().then((value) {
                          Utils(context).stopLoading();
                          AwesomeDialog(
                              context: context,
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              dialogType: DialogType.success,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: '¡Solicitud exitosa!',
                              desc: 'Se ha modificado su contraseña con éxito.\nPor favor vuelva a iniciar sesión con su nueva contraseña.',
                              buttonsTextStyle:
                              const TextStyle(color: Colors.black),
                              showCloseIcon: false,
                              btnOkText: 'ACEPTAR',
                              btnOkColor: Colors.cyan,
                              btnOkOnPress: () {
                                Utils(context).popDialog;
                                Navigator.of(context)
                                    .pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext
                                        context) =>
                                        const Login()));
                              }
                          ).show();
                        }).onError((error, stackTrace) {
                          Utils(context).stopLoading();
                          Utils(context).showErrorDialog(error.toString()).show();
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

  Future<GenericOkPost> callRecoverPasswordUser() async {
    var body = RecoverPasswordBody(
        email: _mail);

    var response = await MyBaseClient().postRecuperarPasswordUser(recoverPasswordBodyToJson(body));
    return response;
  }

  Future<GenericOkPost> callRecoverPasswordCompany() async {
    var body = RecoverPasswordBody(
        email: _mail);

    var response = await MyBaseClient().postRecuperarPasswordCompany(recoverPasswordBodyToJson(body));
    return response;
  }

  Future<GenericOkPost> callChangePassword() async {
    var body = ChangePasswordBody(
        oldPassword: _oldPassKey.text.toString().trim(),
        newPassword: _newPassKey.text.toString().trim()
    );

    String type = "company";
    if (Session.getInstance().isStudent) {
      type = "user";
    }
    var response = await MyBaseClient().putChangePassword(
        changePasswordBodyToJson(body), Session.getInstance().userID, type
    );
    return response;
  }
}
