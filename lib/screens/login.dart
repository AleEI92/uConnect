
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_connect/common/session.dart';
import 'package:u_connect/screens/password_change_reset.dart';
import 'package:u_connect/screens/register.dart';
import '../common/constants.dart';
import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import 'home.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final mailControl = TextEditingController();
  final passControl = TextEditingController();
  bool rememberMe = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadSP();
  }

  void loadSP() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("mail")) {
      setState(() {
        rememberMe = true;
        mailControl.text = prefs.getString("mail")!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: myAppBackground(),
          alignment: Alignment.center,
          width: double.maxFinite,
          height: double.maxFinite,
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _loginFormKey,
                      child: Card(
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8.0,
                        color: Colors.cyan[200],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32),
                          child: Column(
                            children: [
                              // USER MAIL
                              TextFormField(
                                controller: mailControl,
                                validator: (value) {
                                  if (value == null || !EmailValidator.validate(value)) {
                                    return 'Ingrese un correo válido.';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                                decoration: const InputDecoration(
                                    prefixIcon:Icon(Icons.email_rounded),
                                    border: OutlineInputBorder(),
                                    labelText: 'Correo',
                                    hintText: 'Ingrese correo válido'),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              // USER PASSWORD
                              TextFormField(
                                controller: passControl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingrese su contraseña.';
                                  }
                                  return null;
                                },
                                maxLines: 1,
                                maxLength: 16,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  prefixIcon: Icon(Icons.key_rounded),
                                  border: OutlineInputBorder(),
                                  labelText: 'Contraseña',
                                  hintText: 'Ingrese contraseña segura',
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: Checkbox(
                                      value: rememberMe,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          rememberMe = value!;
                                          if (rememberMe == false) {
                                            prefs.remove("mail");
                                          }
                                        });
                                      },
                                    ),
                                  ), //Checkbox
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  const Text('Recordarme'),
                                ],
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                                  backgroundColor: MaterialStateProperty.all(Colors.black45),
                                ),
                                child: const Text(
                                  'INGRESAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_loginFormKey.currentState!.validate()) {
                                    var loginBody = {
                                      "username":
                                          mailControl.text.toString().trim(),
                                      "password":
                                          passControl.text.toString().trim()
                                    };

                                    Utils(context).startLoading();
                                    await MyBaseClient()
                                        .postLogin(loginBody)
                                        .onError((error, stackTrace) {
                                      Utils(context).stopLoading();
                                      Utils(context).showErrorDialog(error.toString()).show();
                                    }).then((value) async {
                                      //Utils(context).stopLoading();
                                      if (value != null) {
                                        setState(() {
                                            prefs.setString("mail", mailControl.text.toString());
                                        });

                                        Session.getInstance().setSessionData(value);

                                        var allCarreras = await MyBaseClient().getCarreras()
                                            .onError((error, stackTrace) {
                                          return [];
                                        });
                                        if (allCarreras.isNotEmpty) {
                                          Session.getInstance().setCarrerasData(allCarreras);
                                          var allCiudades = await MyBaseClient().getCiudades()
                                              .onError((error, stackTrace) {
                                            return [];
                                          });
                                          if (allCiudades.isNotEmpty) {
                                            Session.getInstance().setCiudadesData(allCiudades);
                                            if (!mounted) return;
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                    const Home()));
                                          }
                                          else {
                                            if (!mounted) return;
                                            Utils(context).stopLoading();
                                            Utils(context).showErrorDialog(Constants.disculpe).show();
                                          }
                                        }
                                        else {
                                          if (!mounted) return;
                                          Utils(context).stopLoading();
                                          Utils(context).showErrorDialog(Constants.disculpe).show();
                                        }
                                      }
                                      /////////////////////////////////////
                                    });
                                  }
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  '¿Ha olvidado su contraseña?',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  _recoverPassword();
                                },
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '¿No tienes una cuenta?',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              const Register()));
                                    },
                                    child: const Text(
                                      'Regístrate!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> _recoverPassword() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PasswordChangeReset(isRecovering: true),
    ) ??
        false;
  }
}
