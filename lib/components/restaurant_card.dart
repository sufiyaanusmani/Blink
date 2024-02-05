import 'package:flutter/material.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/screens/restaurant_screen.dart';
import 'package:food_delivery/classes/restaurant.dart';

import 'package:food_delivery/classes/UIColor.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final int customerID;
  final String imageName;

  const RestaurantCard(
      {super.key,
      required this.restaurant,
      required this.customerID,
      required this.imageName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 330,
        // padding: EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 10),
        margin: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ui.val(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(100), // Image radius
                child: Image.asset('images/$imageName', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star_border_rounded,
                              color: Colors.blueGrey, size: 20),
                          Text(
                            '4.3 (5.6k)',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.ownerName,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.blueGrey, size: 17),
                          Text(
                            ' 60 min',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
      onTap: () {
        var db = Mysql();
        db.incrementViewCount(1);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: RestaurantScreen(
                screenHeight: MediaQuery.of(context).size.height.toDouble(),
                restaurant: restaurant,
                customerID: customerID,
              ),
            ),
          ),
        );
      },
    );
  }
}
