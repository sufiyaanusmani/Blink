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

// This variant changes color background on demand used in create new account screen
class PlainTextField2 extends StatefulWidget {
  final String hintText;
  final String labelText;
  final Function(String) onChange;
  final TextEditingController controller;
  final Color background;
  Color textcolor = ui.val(4);
  PlainTextField2(
      {super.key,
      required this.hintText,
      required this.onChange,
      required this.controller,
      required this.labelText,
      required this.background});

  @override
  State<PlainTextField2> createState() => _PlainTextFieldState2();
}

class _PlainTextFieldState2 extends State<PlainTextField2> {
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
          color: widget.background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          cursorColor: ui.val(4).withOpacity(0.7),
          enableInteractiveSelection: false,
          controller: widget.controller,
          style: TextStyle(
            color: widget.textcolor.withOpacity(0.5),
          ),
          decoration: InputDecoration(
            iconColor: Colors.amber,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.textcolor.withOpacity(0.3),
            ),
            border: InputBorder.none,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: widget.textcolor.withOpacity(0.5),
            ),
          ),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
