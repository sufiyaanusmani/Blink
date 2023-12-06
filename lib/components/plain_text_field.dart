import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

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
      color: ui.val(2),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ui.val(2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: widget.controller,
          style: TextStyle(
            color: ui.val(4),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            labelText: widget.labelText,
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
