import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/screens/register.dart';
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
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [0.2, 0.5, 0.8, 0.7],
                colors: [
                  Colors.blue[50]!,
                  Colors.blue[100]!,
                  Colors.blue[200]!,
                  Colors.blue[300]!
                ]
            ),
          ),
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
                                onPressed: () => {
                                  /*if (!_loginFormKey.currentState!.validate()) {

                                  }*/
                                  //else {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const Home()))
                                  //}
                                },
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              InkWell(
                                child: const Text(
                                  '¿Ha olvidado su contraseña?',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {

                                },
                              ),
                              const SizedBox(
                                height: 32.0,
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
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  InkWell(
                                    onTap: () {
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
}
