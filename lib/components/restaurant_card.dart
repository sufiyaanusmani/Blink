import 'package:flutter/material.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/screens/restaurant_screen.dart';
import 'package:food_delivery/classes/restaurant.dart';

import 'package:food_delivery/classes/UIColor.dart';

class RestaurantCard extends StatelessWidget {
  final List<Restaurant> restaurants;
  final int resIndex;
  final int customerID;
  final String imageName;

  const RestaurantCard(
      {super.key,
      required this.restaurants,
      required this.customerID,
      required this.resIndex,
      required this.imageName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 310,
        // padding: EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 10),
        margin: const EdgeInsets.symmetric(
          vertical: 10,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurants[resIndex].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          restaurants[resIndex].description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.star_border_rounded,
                                color: Colors.blueGrey, size: 20),
                            Text(
                              "${restaurants[resIndex].rating} (${restaurants[resIndex].totalRatings})",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.blueGrey, size: 17),
                            Text(
                              ' ${restaurants[resIndex].estimatedTime}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
            // const Divider(),
          ],
        ),
      ),
      onTap: () {
        var db = Mysql();
        print(restaurants[resIndex].restaurantID);
        db.incrementViewCount(restaurants[resIndex].restaurantID);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: RestaurantScreen(
                screenHeight: MediaQuery.of(context).size.height.toDouble(),
                restaurants: restaurants,
                resIndex: resIndex,
                customerID: customerID,
              ),
            ),
          ),
        );
      },
    );
  }
}
