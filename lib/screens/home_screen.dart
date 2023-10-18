import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user.dart';
// import 'package:google_fonts/google_fonts.dart';
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

class FoodItem {
  String name;
  double price;
  int count;

  FoodItem({required this.name, required this.price, this.count = 1});
}

final List<FoodItem> foodItems = [
  FoodItem(name: 'Pizza', price: 10.0, count: 1),
  FoodItem(name: 'Burger', price: 5.0, count: 1),
  FoodItem(name: 'Fries', price: 3.0, count: 1),
  FoodItem(name: 'Soda', price: 2.0, count: 1),
];

class _HomeScreenState extends State<HomeScreen> {
  var db = Mysql();
  String firstName = '';
  List<RestaurantCard> restaurantCards = [];

  bool notificationWidget = false;

  bool loading = true;

  void LoadingFinished() {
    setState(() {
      loading = !loading;
    });
  }

  void toggle() {
    setState(() {
      notificationWidget = !notificationWidget;
    });
  }

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
    double total = foodItems.fold(0, (sum, item) => sum + item.price);

    // User user = ModalRoute.of(context)!.settings.arguments as User;
    // widget.loginID = user.id;
    // if (widget.loginID != -1) {
    //   _getStudent(widget.loginID);
    // }
    // getRestaurants();
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(false), //<-- SEE HERE
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                    // Navigator.of(context).pop(true);
                  }, // <-- SEE HERE
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                  child: IconButton(
                    icon: Icon(Icons.notifications),
                    iconSize: 25,
                    color: Colors.grey,
                    // onPressed: toggle,
                    onPressed: LoadingFinished,
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
            OrderNotification(show: notificationWidget, total: total),
            SizedBox(height: 5),

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
            if (loading)
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
                    Foodshimmer(),
                    Foodshimmer(),
                    Foodshimmer(),
                  ],
                ),
              ),
            if (!loading)
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

            if (loading)
              Column(
                children: [
                  Resshimmer(),
                  Resshimmer(),
                  Resshimmer(),
                ],
              ),
            if (!loading)
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

class Resshimmer extends StatelessWidget {
  const Resshimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black38,
      highlightColor: Colors.grey.shade600,
      period: const Duration(milliseconds: 600),
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        height: 330,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.5)),
      ),
    );
  }
}

class Foodshimmer extends StatelessWidget {
  const Foodshimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black38,
      highlightColor: Colors.grey.shade600,
      period: const Duration(milliseconds: 600),
      child: Container(
        margin: EdgeInsets.only(
          left: 4,
        ),
        height: 300,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(0.5)),
      ),
    );
  }
}

class OrderNotification extends StatelessWidget {
  const OrderNotification({
    super.key,
    required this.total,
    required this.show,
  });

  final double total;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: show ? 400 : 0,
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: !show
          ? SizedBox(width: 0)
          : AnimatedContainer(
              duration: Duration(milliseconds: 100),
              // padding: EdgeInsets.only(left: 10, right: 10, top: 5),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "#1246",
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department_sharp,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Pending",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Expected",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "11:40",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Restraunt",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Pizza fast",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodItems[index];
                        return Container(
                          margin: EdgeInsets.only(top: 2),
                          // padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              if (index == 0) Divider(color: Colors.black87),
                              Row(
                                children: [
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 3, left: 3, bottom: 3),
                                    decoration: BoxDecoration(
                                      // color: Colors.white38,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      border: Border.all(
                                        color: Colors.black45,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      '${foodItem.count}× ',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black54),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${foodItem.name}",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "${foodItem.price} rs",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              Divider(color: Colors.black87),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${total.toStringAsFixed(2)} rs',
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
