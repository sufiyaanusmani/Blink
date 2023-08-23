import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String caption;
  final String reviews;
  final String description;

  RestaurantCard(
      {required this.name,
      required this.caption,
      required this.reviews,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 330,
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
                CircleAvatar(
                  child: Text('SU'),
                  backgroundColor: Colors.white,
                  radius: 25,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.fromSize(
                size: Size.fromRadius(100), // Image radius
                child: Image.asset('images/kfc.jpg', fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(caption),
                Text(reviews),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(description),
          ],
        ),
      ),
      onTap: () {
        print('pressed $name');
      },
    );
  }
}
