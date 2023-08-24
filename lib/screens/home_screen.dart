import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;
  User user;
  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = Mysql();
  String firstName = '';

  void _getStudent(int loginID) async {
    var conn = await db.getConnection();
    await conn.connect();
    var results = await conn
        .execute('SELECT first_name FROM Customer WHERE id=$loginID;');
    for (var row in results.rows) {
      setState(() {
        firstName = row.assoc()['first_name']!;
      });
    }
    conn.close();
  }

  @override
  Widget build(BuildContext context) {
    // User user = ModalRoute.of(context)!.settings.arguments as User;
    // widget.loginID = user.id;
    // if (widget.loginID != -1) {
    //   _getStudent(widget.loginID);
    // }
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Welcome, ${widget.user.firstName}',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                // itemCount: 5,
                padding: EdgeInsets.all(10.0),
                children: [
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
