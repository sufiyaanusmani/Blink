import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        height: 370,
        padding: EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 10),
        margin: EdgeInsets.symmetric(
          vertical: 2,
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
                Text(
                  name,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
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
            SizedBox(height: 10),
            Text(description),
            SizedBox(height: 10),
            Divider(),
          ],
        ),
      ),
      onTap: () {
        print('pressed $name');
      },
    );
  }
}
