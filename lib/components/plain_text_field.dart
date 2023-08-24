import 'package:flutter/material.dart';

class PlainTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChange;
  PlainTextField({required this.hintText, required this.onChange});

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
          decoration: InputDecoration(
            hintText: this.hintText,
            border: InputBorder.none,
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}
