import 'package:flutter/material.dart';

class ui {
  static List<Color> colors = [
    const Color.fromARGB(255, 15, 15, 15), // 0
    const Color.fromARGB(255, 35, 35, 35), // 1
    const Color.fromARGB(255, 50, 50, 50), // 2
    Colors.grey.shade600, // 3
    const Color.fromARGB(190, 255, 255, 255), // 4
    const Color.fromARGB(255, 46, 46, 46), // 5
    Colors.white38, //6
    const Color(0xFFFF4500), //7
    const Color.fromARGB(158, 255, 109, 31), //8
    const Color(0xFF00CED1), //9
    const Color.fromARGB(255, 255, 106, 80), //10
  ];

  static Color val(int index) {
    return colors[index];
  }

  static Color txt() {
    return colors[4];
  }

  static Color txtop() {
    return colors[6];
  }
}
