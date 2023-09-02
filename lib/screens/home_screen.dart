import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/classes/cart.dart';

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
  List<RestaurantCard> restaurantCards = [];

  // void _getStudent(int loginID) async {
  //   // var conn = await db.getConnection();
  //   // await conn.connect();
  //   // var results = await conn
  //   //     .execute('SELECT first_name FROM Customer WHERE id=$loginID;');
  //   Iterable<ResultSetRow> rows = await db.getResults(
  //       'SELECT customer_id, first_name FROM Customer WHERE id=$loginID;');
  //   for (var row in rows) {
  //     setState(() {
  //       firstName = row.assoc()['first_name']!;
  //       Cart.customerID = int.parse(row.assoc()['customer_id']!);
  //     });
  //   }
  // }

  void getRestaurants() async {
    List<Restaurant> r = await Restaurant.getRestaurants();
    List<RestaurantCard> tempRestaurantCards = [];
    for (Restaurant res in r) {
      print('got a card');
      tempRestaurantCards.add(RestaurantCard(restaurant: res));
    }

    setState(() {
      restaurantCards = tempRestaurantCards;
    });
  }

  // void getRestaurantsCards() {
  //   for (Restaurant r in widget.restaurants) {
  //     setState(() {
  //       restaurantCards.add(
  //         RestaurantCard(
  //           restaurant: r,
  //         ),
  //       );
  //     });
  //   }
  // }

  @override
  void initState() {
    if (restaurantCards.isEmpty) {
      getRestaurants();
    }
    Cart.customerID = widget.user.id;
    // TODO: implement initState
    super.initState();
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
                physics: BouncingScrollPhysics(),
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
              children: restaurantCards,
            ),
            // ListView.builder(
            //   itemBuilder: (context, index) {
            //     return RestaurantCard(restaurant: restaurants[index]);
            //   },
            //   itemCount: restaurants.length,
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
