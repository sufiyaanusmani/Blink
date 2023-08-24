import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/restaurant.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;
  User user;
  List<Restaurant> restaurants;

  HomeScreen({super.key, required this.user, required this.restaurants});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = Mysql();
  String firstName = '';

  void _getStudent(int loginID) async {
    // var conn = await db.getConnection();
    // await conn.connect();
    // var results = await conn
    //     .execute('SELECT first_name FROM Customer WHERE id=$loginID;');
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT first_name FROM Customer WHERE id=$loginID;');
    for (var row in rows) {
      setState(() {
        firstName = row.assoc()['first_name']!;
      });
    }
  }

  List<RestaurantCard> getRestaurantsCards() {
    List<RestaurantCard> res = [];
    for (Restaurant r in widget.restaurants) {
      res.add(
        RestaurantCard(
          name: r.name,
          caption: r.ownerName,
          reviews: '00:00',
          description:
              'Second line of text in here for this card element or component',
        ),
      );
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // User user = ModalRoute.of(context)!.settings.arguments as User;
    // widget.loginID = user.id;
    // if (widget.loginID != -1) {
    //   _getStudent(widget.loginID);
    // }
    // getRestaurants();
    return SafeArea(
      child: Scaffold(
        body: ListView(
          scrollDirection: Axis.vertical,
          // itemCount: 5,
          padding: EdgeInsets.all(10.0),
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                'Welcome, ${widget.user.firstName}',
                style: GoogleFonts.caveat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
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
            Column(
              children: getRestaurantsCards(),
            ),
            // ListView.builder(
            //   itemBuilder: (context, index) {
            //     return RestaurantCard(
            //       name: widget.restaurants[index].name,
            //       caption: widget.restaurants[index].ownerName,
            //       reviews: '00:00',
            //       description:
            //           'Second line of text in here for this card element or component',
            //     );
            //   },
            //   itemCount: widget.restaurants.length,
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            // ),
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
