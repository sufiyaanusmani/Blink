import 'package:flutter/material.dart';

import '../screens/restaurant_screen.dart';

class Resshimmer extends StatelessWidget {
  const Resshimmer({
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
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        height: 330,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.5)),
      ),
    ));
  }
}
