import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final String hintText;
  PasswordTextField({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: this.hintText,
            border: InputBorder.none,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
