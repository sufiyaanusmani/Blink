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
    if (this.mounted) {
      setState(() {
        restaurantCards = tempRestaurantCards;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        shadowColor: Colors.grey.shade800,
        automaticallyImplyLeading: false,
        title: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Blink',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.notifications,
                  size: 25,
                  color: Colors.grey,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(110, 33, 33, 33),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        // itemCount: 5,
        padding: EdgeInsets.all(10.0),
        children: [
          SizedBox(height: 5),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Column(
          //     textDirection: TextDirection.rtl,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Text(
          //         'Welcome,',
          //         style: TextStyle(
          //           fontSize: 30,
          //           color: Colors.grey.shade800,
          //         ),
          //       ),
          //       Text(
          //         '${widget.user.firstName}',
          //         style: TextStyle(
          //           fontWeight: FontWeight.w600,
          //           fontSize: 30,
          //           color: Colors.grey.shade800,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Trending',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              // itemCount: 5,
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10,
              ),
              children: [
                SmallRestaurantCard(
                  imageID: 'kfc',
                  itemName: 'itemname',
                  itemDesc: 'itemDisc',
                ),
                SmallRestaurantCard(
                  imageID: 'mac',
                  itemName: 'itemname',
                  itemDesc: 'itemDisc',
                ),
                SmallRestaurantCard(
                  imageID: 'pizzahut',
                  itemName: 'itemname',
                  itemDesc: 'itemDisc',
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Discover',
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 15),
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


