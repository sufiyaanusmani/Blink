import 'package:flutter/material.dart';

class LargeButton extends StatefulWidget {
  final Color color;
  final Widget buttonChild;
  final double verticalPadding;
  final VoidCallback onPressed;

  LargeButton(
      {required this.color,
      required this.buttonChild,
      required this.verticalPadding,
      required this.onPressed});

  @override
  State<LargeButton> createState() => _LargeButtonState();
}

class _LargeButtonState extends State<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding,
          ),
          child: widget.buttonChild,
        ),
      ),
    );
  }
}
