import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:food_delivery/mysql.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/screens/home_screen.dart';
import 'package:food_delivery/screens/restaurant_screen.dart';
import 'package:food_delivery/classes/restaurant.dart';
// import 'package:mysql1/mysql1.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 330,
        // padding: EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 10),
        margin: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade800,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SizedBox(height: 10),
            // Stack(
            //   children: [
            //     Image.asset(
            //       'images/kfc.jpg',
            //       fit: BoxFit.cover,
            //       width: double.infinity,
            //       height: 300,
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             Color.fromARGB(255, 255, 0, 0),
            //             Color.fromARGB(255, 0, 149, 255).withOpacity(1),
            //           ],
            //         ),
            //       ),
            //       width: double.infinity,
            //       height: double.infinity,
            //     ),
            //     Positioned(
            //       bottom: 0,
            //       left: 0,
            //       right: 0,
            //       child: Container(
            //         height: 20,
            //         decoration: BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //               color: const Color.fromARGB(255, 255, 0, 0)
            //                   .withOpacity(1),
            //               spreadRadius: 20,
            //               blurRadius: 50,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: SizedBox.fromSize(
                size: Size.fromRadius(100), // Image radius
                child: Image.asset('images/kfc.jpg', fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Icon(Icons.star, color: Colors.blueGrey),
                          for (int i = 0; i < 2; i++)
                            Icon(Icons.star_border_outlined,
                                color: Colors.blueGrey),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.ownerName,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '4.3(5.6k)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
      onTap: () {
        print('pressed ${restaurant.name}');
        var db = Mysql();
        db.incrementViewCount(restaurant.restaurantID);
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
