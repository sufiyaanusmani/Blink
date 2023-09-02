import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChange;
  TextEditingController controller;
  PasswordTextField(
      {required this.hintText,
      required this.onChange,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: this.hintText,
            border: InputBorder.none,
            labelText: 'Password',
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}
