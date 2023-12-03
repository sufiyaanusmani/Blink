import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onChange;
  final TextEditingController controller;
  const PasswordTextField(
      {super.key,
      required this.hintText,
      required this.onChange,
      required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
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
          controller: widget.controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            labelText: 'Password',
          ),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
