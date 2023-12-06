import 'package:flutter/material.dart';

class MyHours extends StatelessWidget {
  final int hours;

  const MyHours({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          hours < 10 ? '0$hours' : hours.toString(),
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white70,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
