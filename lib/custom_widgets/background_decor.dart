import 'package:flutter/material.dart';

BoxDecoration myAppBackground() {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [
          0.2,
          0.5,
          0.8,
          0.7
        ],
        colors: [
          Colors.blue[50]!,
          Colors.blue[100]!,
          Colors.blue[200]!,
          Colors.blue[300]!
        ]),
  );
}
