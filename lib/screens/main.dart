import 'dart:async';

import 'package:flutter/material.dart';
import 'package:u_connect/screens/login.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.cyan,
        ),
        fontFamily: 'Inter',
        //scaffoldBackgroundColor: const Color(0xE6FFFFFF),
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const Login())));

    return Builder(
        builder: (context) {
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
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
