import 'package:flutter/material.dart';

class PlainTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final Function(String) onChange;
  final TextEditingController controller;
  const PlainTextField(
      {super.key,
      required this.hintText,
      required this.onChange,
      required this.controller,
      required this.labelText});

  @override
  State<PlainTextField> createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField> {
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
          decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              labelText: widget.labelText),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
