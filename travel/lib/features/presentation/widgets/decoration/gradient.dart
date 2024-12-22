import 'package:flutter/material.dart';

BoxDecoration getGradientDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color.fromRGBO(205, 207, 255, 1),
        Color.fromRGBO(255, 248, 241, 1),
      ],
    ),
  );
}
