import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

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
      color: ui.val(2),
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ui.val(1).withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          cursorColor: ui.val(4).withOpacity(0.7),
          enableInteractiveSelection: false,
          controller: widget.controller,
          obscureText: true,
          style: TextStyle(
            color: ui.val(4),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            labelText: 'Password',
            hintStyle: TextStyle(
              color: ui.val(4).withOpacity(0.3),
            ),
            labelStyle: TextStyle(
              color: ui.val(4).withOpacity(0.5),
            ),
          ),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
