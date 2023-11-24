import 'package:flutter/services.dart';
import 'package:mysql_client/mysql_client.dart';
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
  int price;
  int count;

  FoodItem({required this.name, required this.price, required this.count});
}

late List<FoodItem> foodItems = [];

class _HomeScreenState extends State<HomeScreen> {
  var db = Mysql();
  String firstName = '';
  List<RestaurantCard> restaurantCards = [];

  bool notificationWidget = false;

  bool loading = true;

  // void LoadingFinished() {
  //   setState(() {
  //     loading = !loading;
  //   });
  // }

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
    setState(() {
      loading = true;
    });
    List<Restaurant> r = await Restaurant.getRestaurants();
    List<RestaurantCard> tempRestaurantCards = [];
    for (Restaurant res in r) {
      print('got a card');
      tempRestaurantCards
          .add(RestaurantCard(restaurant: res, customerID: widget.user.id));
    }
    if (this.mounted) {
      setState(() {
        restaurantCards = tempRestaurantCards;
      });
    }
    setState(() {
      loading = false;
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

  void getOrder() async {
    var db = Mysql();
    List<FoodItem> temp = [];
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT P.name, D.quantity, (D.quantity * P.price) AS price FROM Orders O INNER JOIN OrderDetail D ON (O.order_id = D.order_id) INNER JOIN Product P ON (D.product_id = P.product_id) WHERE O.customer_id = ${widget.user.id};');
    if (rows.length == 1) {
      for (var row in rows) {
        temp.add(FoodItem(
            name: row.assoc()['name']!,
            price: int.parse(row.assoc()['price']!),
            count: int.parse(row.assoc()['quantity']!)));
      }
      setState(() {
        foodItems = temp;
      });
    }
  }

  @override
  void initState() {
    if (restaurantCards.isEmpty) {
      getRestaurants();
    }
    getOrder();
    Cart.customerID = widget.user.id;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
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
                  child: IconButton(
                    icon: Icon(Icons.notifications),
                    iconSize: 25,
                    color: Colors.grey,
                    onPressed: toggle,
                    // onPressed: () {
                    //   print('pressed');
                    //   print('pressed');
                    // },
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
            // OrderNotification(show: notificationWidget, total: total),
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
              children: [
                Resshimmer(),
                Resshimmer(),
                Resshimmer(),
              ],
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
                    onPressed: toggle,
                    // onPressed: () {
                    //   print('pressed');
                    //   print('pressed');
                    // },
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
            OrderNotification(
                show: notificationWidget, customerID: widget.user.id),
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
            )
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

class OrderNotification extends StatefulWidget {
  OrderNotification({
    super.key,
    required this.customerID,
    required this.show,
  });

  final int customerID;
  final bool show;

  @override
  State<OrderNotification> createState() => _OrderNotificationState();
}

class _OrderNotificationState extends State<OrderNotification> {
  late int orderID = 0;

  late String status = 'Pending';

  late String restaurantName = '';
  late String time = "None";

  late int price = 0;
  void getOrderInfo() async {
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT O.order_id, O.status, R.name, O.price, P.time FROM Orders O INNER JOIN Restaurant R ON (O.restaurant_id = R.restaurant_id) LEFT JOIN Preschedule P ON (O.order_id = P.order_id) WHERE O.customer_id=${widget.customerID} AND O.status IN ("pending", "preparing");');
    if (rows.length == 1) {
      for (var row in rows) {
        setState(() {
          orderID = int.parse(row.assoc()['order_id']!);
          status = row.assoc()['status']!;
          restaurantName = row.assoc()['name']!;
          price = int.parse(row.assoc()['price']!);
          var timeTemp = row.assoc()['time'] ?? 'None';
          setState(() {
            time = timeTemp;
          });
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getOrderInfo();
    print(widget.customerID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: widget.show ? 400 : 0,
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: !widget.show
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
                          "#$orderID",
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
                          status,
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
                          time,
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
                          restaurantName,
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
                              OrderStatusProductRow(foodItem: foodItem),
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
                          'Rs. $price',
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

class OrderStatusProductRow extends StatelessWidget {
  const OrderStatusProductRow({
    super.key,
    required this.foodItem,
  });

  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.only(top: 3, left: 3, bottom: 3),
          decoration: BoxDecoration(
            // color: Colors.white38,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: Colors.black45,
              width: 1.0,
            ),
          ),
          child: Text(
            '${foodItem.count}× ',
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
        ),
        SizedBox(width: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${foodItem.name}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "${foodItem.price} rs",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
        SizedBox(width: 10),
      ],
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
