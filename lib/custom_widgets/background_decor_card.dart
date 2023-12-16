
import 'package:flutter/material.dart';

BoxDecoration myCardBackground() {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue.shade200,
          Colors.blue.shade100,
          Colors.blue.shade50,
        ]),
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(12)),
  );
}
