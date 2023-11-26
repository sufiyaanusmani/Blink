import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  TitleButton(
      {required this.title, required this.subtitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
