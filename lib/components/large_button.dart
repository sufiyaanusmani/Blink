import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

class LargeButton extends StatefulWidget {
  final Color color;
  final Widget buttonChild;
  final double verticalPadding;
  final VoidCallback onPressed;

  const LargeButton(
      {super.key,
      required this.color,
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
      color: ui.val(2).withOpacity(0.3),
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
