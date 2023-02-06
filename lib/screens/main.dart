import 'dart:async';

import 'package:flutter/material.dart';
import 'package:u_connect/screens/login.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.cyan,
      ),
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const Login())));

    return Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/images/logo.png'),
                      width: 160,
                      height: 160,
                    ),
                    Text(
                      'U-Connect',
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
