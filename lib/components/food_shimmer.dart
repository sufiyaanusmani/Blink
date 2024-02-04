import 'package:flutter/material.dart';

import '../screens/restaurant_screen.dart';

class Foodshimmer extends StatelessWidget {
  const Foodshimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: const Color.fromARGB(96, 143, 143, 143),
      highlightColor: Colors.grey.shade600,
      period: const Duration(milliseconds: 600),
      child: Container(
        margin: EdgeInsets.only(
          left: 4,
        ),
        height: 300,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(0.5)),
      ),
    ));
  }
}
