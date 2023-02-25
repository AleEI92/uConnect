import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/login_body.dart';
import 'package:u_connect/screens/password_reset.dart';
import 'package:u_connect/screens/register.dart';
import '../custom_widgets/background_decor.dart';
import '../http/base_client.dart';
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
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
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
                                maxLength: 8,
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
                                  backgroundColor: MaterialStateProperty.all(Colors.white54),
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
                                      "username": mailControl.text.toString().trim(),
                                      "password": passControl.text.toString().trim()
                                    };
                                    await MyBaseClient()
                                        .postLogin(loginBody)
                                        .then((value) => {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const Home()))
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
                                      print('PRINT LOG: Register Clicked!');
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
      context: context,
      builder: (context) => PasswordReset(),
    ) ??
        false;
  }
}