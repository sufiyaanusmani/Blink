import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/user1.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/classes/restaurant.dart';
// import 'package:food_delivery/classes/cart.dart';

import 'package:food_delivery/classes/UIColor.dart';
import '../classes/customer.dart';
// import '../classes/trending_product.dart';
import '../components/food_shimmer.dart';
import '../components/reshimmer.dart';

late bool show = true;
final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  final Customer customer;
  final List<Restaurant> restaurants;

  const HomeScreen(
      {super.key, required this.customer, required this.restaurants});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  void toggleshow() {
    setState(() {
      show = !show;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        shadowColor: ui.val(0),
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
                  onPressed: () {
                    print("Pressed: ${widget.customer.uid}");
                  },
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
        children: [
          OrderNotification(customerID: widget.customer.uid),
          const SizedBox(height: 35),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Trending',
              style: TextStyle(
                fontSize: 20,
                color: ui.val(4),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Discover',
              style: TextStyle(
                fontSize: 40,
                color: ui.val(4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          StreamBuilder<QuerySnapshot>(
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("error");
              }
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                );
              }
              return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  Restaurant restaurant = Restaurant(
                      restaurantID: document.id,
                      name: data["name"],
                      ownerName: data["ownername"]);
                  return RestaurantCard(
                      restaurant: restaurant,
                      customerID: 1,
                      imageName: "kfc.jpg");
                }).toList(),
              );
            },
            stream: _firestore.collection('restaurants').snapshots(),
          ),
        ],
      ),
    );
  }
}

class FoodItem {
  String name;
  int price;
  int count;

  FoodItem({required this.name, required this.price, required this.count});
}

class OrderNotification extends StatefulWidget {
  OrderNotification({super.key, required this.customerID});

  final String customerID;

  @override
  State<OrderNotification> createState() => _OrderNotificationState();
}

class _OrderNotificationState extends State<OrderNotification> {
  Stream<QuerySnapshot>? documentStream;
  late int orderID = 0;
  // late bool show = false;
  late String status = 'Pending';

  late String restaurantName = '';
  late String time = "None";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      documentStream = FirebaseFirestore.instance
          .collection("orders")
          .where("customerid", isEqualTo: widget.customerID)
          .where("status", whereIn: ["pending", "processing"]).snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    String restaurantName = "";
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ui.val(0),
    ));
    return StreamBuilder<QuerySnapshot>(
      stream: documentStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (!show) {
          return AnimatedContainer(
              duration: Duration(milliseconds: 150),
              height: show ? 400 : 0,
              decoration: BoxDecoration(
                  color: ui.val(2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SizedBox(width: 0));
        } else {
          return AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: 400,
            decoration: BoxDecoration(
              color: ui.val(2),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order",
                            style: TextStyle(
                              fontSize: 30,
                              color: ui.val(4),
                            ),
                          ),
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_sharp,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ui.val(4),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            document["status"],
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Expected",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ui.val(4),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Restaurant",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ui.val(4),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data["restaurant"]["name"],
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          );
        }
      },
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
              color: ui.val(4).withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: Text(
            '${foodItem.count}× ',
            style: TextStyle(
              fontSize: 20,
              color: ui.val(4).withOpacity(0.5),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${foodItem.name}",
                style: TextStyle(
                  fontSize: 20,
                  color: ui.val(4),
                ),
              ),
              Text(
                "${foodItem.price} rs",
                style: TextStyle(
                  fontSize: 15,
                  color: ui.val(4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
