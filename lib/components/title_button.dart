import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  TitleButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 2,
            )),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                title,
              ),
              Icon(Icons.arrow_forward_ios),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
