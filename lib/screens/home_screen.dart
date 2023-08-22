import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/mysql.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = new Mysql();

  void _getStudent() async {
    var conn = await db.getConnection();
    await conn.connect();
    var results = await conn.execute('SELECT roll_no, name FROM User;');
    for (var row in results.rows) {
      print(row.assoc());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Welcome, Sufiyaan',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            GestureDetector(
              child: Container(
                width: 60,
                height: 60,
                color: Colors.blue,
              ),
              onTap: () {
                _getStudent();
              },
            ),
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
            Divider(),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                // itemCount: 5,
                padding: EdgeInsets.all(10.0),
                children: [
                  RestaurantCard(
                    name: 'KFC',
                    caption: 'Caption',
                    reviews: '00:00',
                    description:
                        'Second line of text in here for this card element or component',
                  ),
                  Divider(),
                  RestaurantCard(
                    name: 'Mc Donalds',
                    caption: 'Caption',
                    reviews: '00:00',
                    description:
                        'Second line of text in here for this card element or component',
                  ),
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
