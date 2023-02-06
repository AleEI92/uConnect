import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          height: double.maxFinite,
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // USER MAIL
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo',
                        hintText: 'Ingrese correo valido'),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  // USER PASSWORD
                  TextField(
                    maxLength: 8,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                        hintText: 'Ingrese contraseña segura'),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
