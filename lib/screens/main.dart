import 'dart:async';

import 'package:flutter/material.dart';
import 'package:u_connect/screens/login.dart';
import '../custom_widgets/background_decor.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF64B5F6),
        ),
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
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
                decoration: myAppBackground(),
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
