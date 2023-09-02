import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/screens/home_screen.dart';
import 'package:food_delivery/screens/restaurant_screen.dart';
import 'package:food_delivery/classes/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

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
                  restaurant.name,
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
                Text(restaurant.ownerName),
                Text(restaurant.ownerName),
              ],
            ),
            SizedBox(height: 10),
            Text(restaurant.ownerName),
            SizedBox(height: 10),
            Divider(),
          ],
        ),
      ),
      onTap: () {
        print('pressed ${restaurant.name}');
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: RestaurantScreen(
                screenHeight: MediaQuery.of(context).size.height.toDouble(),
                restaurant: restaurant,
              ),
            ),
          ),
        );
      },
    );
  }
}
