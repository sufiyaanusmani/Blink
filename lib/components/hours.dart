import 'package:flutter/material.dart';

class MyHours extends StatelessWidget {
  int hours;

  MyHours({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            hours < 10 ? '0' + hours.toString() : hours.toString(),
            style: TextStyle(
              fontSize: 40,
              color: const Color.fromARGB(255, 2, 2, 2),
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}