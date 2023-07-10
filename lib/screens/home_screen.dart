import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Headline'),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                // itemCount: 5,
                padding: EdgeInsets.all(10.0),
                children: [
                  SmallRestaurantCard(imageID: 'kfc'),
                  SmallRestaurantCard(imageID: 'mac'),
                  SmallRestaurantCard(imageID: 'pizzahut'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container(
// width: 170,
// margin: EdgeInsets.all(2),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10.0),
// color: Colors.grey.shade300,
// ),
// child: Image.asset(
// 'images/kfc.jpg',
// fit: BoxFit.fill,
// ),
// );
