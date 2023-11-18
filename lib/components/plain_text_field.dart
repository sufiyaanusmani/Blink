import 'package:flutter/material.dart';

class PlainTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function(String) onChange;
  TextEditingController controller;
  PlainTextField(
      {required this.hintText,
      required this.onChange,
      required this.controller,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: this.hintText,
              border: InputBorder.none,
              labelText: this.labelText),
          onChanged: onChange,
        ),
      ),
    );
  }
}
