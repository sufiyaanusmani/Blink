import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:food_delivery/api/firebase_api.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/small_restaurant_card.dart';
import 'package:food_delivery/components/restaurant_card.dart';
import 'package:food_delivery/firebase_services.dart';
import 'package:food_delivery/classes/user1.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/classes/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/classes/UIColor.dart';
import '../classes/trending_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

late bool show = true;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;
  User1 user;
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

class _HomeScreenState extends State<HomeScreen> {
  var db = FirebaseServices();
  String firstName = '';
  List<RestaurantCard> restaurantCards = [];
  List<SmallRestaurantCard> trendingProducts = [];

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

  void toggleshow() {
    setState(() {
      show = !show;
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
    for (int index = 0; index < r.length; index++) {
      Restaurant res = r[index];
      String imageName = "kfc.jpg";
      String resName = res.name;
      resName = resName.toLowerCase();
      if (resName.contains("burger")) {
        imageName = "burger.jpg";
      } else if (resName.contains("cafe")) {
        imageName = "cafe.jpg";
      } else if (resName.contains("dhaba")) {
        imageName = "dhaba.jpg";
      } else if (resName.contains("juice")) {
        imageName = "juice.jpg";
      } else if (resName.contains("limca")) {
        imageName = "limca.jpg";
      } else if (resName.contains("pathan")) {
        imageName = "pathan.jpg";
      } else if (resName.contains("pizza")) {
        imageName = "pizza.jpg";
      } else if (resName.contains("shawarma")) {
        imageName = "shawarma.jpg";
      } else {
        imageName = "kfc.jpg";
      }
      tempRestaurantCards.add(RestaurantCard(
        restaurants: r,
        resIndex: index,
        customerID: widget.user.id,
        imageName: imageName,
      ));
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


  void updateFCMToken(String customerId, String newToken) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get a reference to the document within the "customers" collection
    DocumentReference customerRef =
        firestore.collection('customers').doc(customerId);

    // Update the document with the new fcmToken value
    customerRef.update({
      'fcmToken': newToken,
    }).then((_) {
      print('FCM token updated successfully');
    }).catchError((error) {
      print('Error updating FCM token: $error');
    });
  }

  List<String> imageNames = ['yellow', 'blue', 'green', 'bleen', 'purple'];

  String getRandomImageName() {
    Random random = Random();
    int index = random.nextInt(imageNames.length);
    return imageNames[index];
  }
  void getTrendingProducts() async {
    List<TrendingProduct> temp = [];
    List<SmallRestaurantCard> cards = [];
    try {
      temp = await TrendingProduct.getTrendingProducts();
    } catch (e) {
      // Handle the error (e.g., show an error message)
      print('Error fetching trending products: $e');
      return; // Exit the method early
    }
    for (TrendingProduct product in temp) {
      String randomImageName = getRandomImageName();
      cards.add(SmallRestaurantCard(
          imageID: randomImageName,
          itemName: product.productName,
          productID: product.productID.toString(),
          restaurantName: product.restaurantName,
          restaurantID: product.restaurantID.toString(),
          liked: product.liked,
          categoryID: product.categoryID,
          categoryName: product.categoryName,
          price: product.price));
    }
    setState(() {
      trendingProducts = cards;
    });
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
      updateFCMToken(getCustomer()!, value);
    });

    if (restaurantCards.isEmpty) {
      getRestaurants();
    }

    if (trendingProducts.isEmpty) {
      getTrendingProducts();
    }

    Cart.customerID = widget.user.id;

    super.initState();
  }

  String? getCustomer() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user!.uid;
  }

  bool isBottomSheetDisplayed = false;

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
        backgroundColor: ui.val(0),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: ui.val(0),
            statusBarColor: ui.val(0),
          ),
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
                      toggleshow();

                      // FlutterBackgroundService().invoke('setAsForeground');
                      // print("foreground");
                    },
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
                  color: ui.val(4),
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

            Divider(color: ui.val(1)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Discover',
                style: TextStyle(
                  fontSize: 40,
                  color: ui.val(4),
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
    // double total = foodItems.fold(0, (sum, item) => sum + item.price);

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
        backgroundColor: ui.val(0),
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
                    onPressed: toggle,
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
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .doc(getCustomer())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var customerData = snapshot.data!.data();
                  if (customerData != null) {
                    // Explicitly cast customerData to a Map<String, dynamic>
                    var customerMap = customerData as Map<String, dynamic>;
                    var reviewData = customerMap['Review'];
                    if (reviewData != null &&
                        reviewData['Placed'] == false &&
                        !isBottomSheetDisplayed) {
                      var restaurantId = reviewData['Restaurant ID'];
                      var restaurantName = reviewData['Restaurant Name'];

                      isBottomSheetDisplayed = true;
                      // Show bottom modal in a separate microtask
                      Future.microtask(() {
                        showModalBottomSheet(
                          context: context,
                          // isDismissible: false,
                          barrierColor: const Color.fromARGB(101, 0, 0, 0),
                          backgroundColor: ui.val(0),
                          builder: (BuildContext context) {
                            double resRating = 3.00;

                            return Container(
                              // height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),

                                  SizedBox(height: 30),
                                  Text(
                                    'Rate your experience at',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: ui.val(4),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 1, bottom: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.shade200
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Center(
                                      child: Text(
                                        '$restaurantName',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: ui.val(4),
                                          // fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  // Text(
                                  //   'Restaurant ID: $restaurantId',
                                  //   style: TextStyle(fontSize: 16),
                                  // ),

                                  RatingBar.builder(
                                    glowColor: Colors.black,
                                    glowRadius: 1,
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    unratedColor: ui.val(10).withOpacity(0.1),
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star_rate_rounded,
                                      color: ui.val(10),
                                    ),
                                    onRatingUpdate: (rating) {
                                      // print(rating);
                                      setState(() {
                                        resRating = rating;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 35),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ui.val(10).withOpacity(0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.of(context).pop();

                                        DocumentReference restaurantRef =
                                            FirebaseFirestore.instance
                                                .collection('restaurants')
                                                .doc(restaurantId);

                                        // Get the restaurant document
                                        DocumentSnapshot restaurantSnapshot =
                                            await restaurantRef.get();

                                        // Access the "Review" map
                                        Map<String, dynamic>? reviewMap =
                                            restaurantSnapshot['Review'];

                                        if (reviewMap != null) {
                                          // Extract "Stars" and "Rating Count" from the "Review" map
                                          double resStars =
                                              reviewMap['Stars'].toDouble() ??
                                                  0.0;
                                          print("ddsa");
                                          double resRatingCount =
                                              reviewMap['Rating Count']
                                                      .toDouble() ??
                                                  0.0;

                                          // Calculate the new rating
                                          double newRating =
                                              ((resStars * resRatingCount) +
                                                      resRating) /
                                                  (resRatingCount + 1.0);
                                          // Update the "Review" map with new values
                                          reviewMap['Stars'] = double.parse(
                                              newRating.toStringAsFixed(2));
                                          reviewMap['Rating Count'] =
                                              resRatingCount + 1.0;

                                          // Update the restaurant document with the modified "Review" map
                                          restaurantRef.update({
                                            'Review': reviewMap,
                                          }).then((value) {
                                            print(
                                                'Restaurant rating updated successfully');

                                            FirebaseFirestore.instance
                                                .collection('customers')
                                                .doc(getCustomer())
                                                .update({
                                              'Review.Placed': true,
                                              'Review.Restaurant ID': "",
                                              'Review.Restaurant Name': "",
                                            }).then((value) {
                                              print(
                                                  'Review Placed updated successfully');
                                            }).catchError((error) {
                                              print(
                                                  'Error updating Review Placed: $error');
                                            });
                                          }).catchError((error) {
                                            print(
                                                'Error updating restaurant rating: $error');
                                          });
                                        } else {
                                          print(
                                              'Review map not found in restaurant document');
                                        }
                                      },
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                              color: ui.val(1),
                                              // fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        );
                      });
                    }
                  }
                }
                return SizedBox(); // Return an empty container if no review is placed
              },
            ),

            OrderNotification(customerID: widget.user.id),

            SizedBox(height: 35),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Trending',
                style: TextStyle(
                  fontSize: 20,
                  color: ui.val(4),
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
                children: trendingProducts,
              ),
            ),
            Divider(
              color: ui.val(1),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Discover',
                style: TextStyle(
                  fontSize: 40,
                  color: ui.val(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 15),

            Column(
              children: restaurantCards,
            ),
//
//
//
            // StreamBuilder<DocumentSnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('customers')
            //       .doc(getCustomer()) // Replace with the actual document ID
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       var customerData =
            //           snapshot.data!.data()! as Map<String, dynamic>;
            //       var reviewPlaced =
            //           (customerData['Review'] as Map<String, dynamic>?) ?? {};

            //       // Check if review has been placed for any restaurant
            //       if (reviewPlaced['Placed'] == false) {
            //         // Get the restaurant ID and name from the reviewPlaced map
            //         var restaurantId = reviewPlaced['Restaurant ID'];
            //         var restaurantName = reviewPlaced['Restaurant Name'];

            //         // Show bottom modal
            //         showModalBottomSheet(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return Container(
            //               padding: EdgeInsets.all(16),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text(
            //                     'Review has been placed for:',
            //                     style: TextStyle(fontSize: 18),
            //                   ),
            //                   SizedBox(height: 8),
            //                   Text(
            //                     'Restaurant ID: $restaurantId',
            //                     style: TextStyle(fontSize: 16),
            //                   ),
            //                   Text(
            //                     'Restaurant Name: $restaurantName',
            //                     style: TextStyle(fontSize: 16),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         );
            //       }
            //     }
            //     return Center(child: CircularProgressIndicator());
            //   },
            // ),
            //
            //
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
      baseColor: const Color.fromARGB(96, 143, 143, 143),
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
      baseColor: const Color.fromARGB(96, 143, 143, 143),
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
  OrderNotification({super.key, required this.customerID});

  final int customerID;

  @override
  State<OrderNotification> createState() => _OrderNotificationState();
}

class _OrderNotificationState extends State<OrderNotification> {
  late String orderID = "";
  // late bool show = false;
  late String status = 'Pending';

  late String restaurantName = '';
  late String time = "-";
  late List<FoodItem> foodItems = [];
  late int price = 0;

  void getOrderInfo() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query Firestore for orders matching the customer ID and status
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('orders')
          .where('customerid', isEqualTo: user!.uid)
          .where('status', whereIn: ['pending', 'preparing'])
          .limit(1) // Limit to 1 document
          .get();

      // Check if there is exactly one document found
      if (querySnapshot.size == 1) {
        // Access the first document
        DocumentSnapshot<Map<String, dynamic>> doc = querySnapshot.docs.first;

        // Extract data from the document
        String orderId = doc.id;
        String orderStatus = doc['status'];
        String restaurant = doc['restaurant']['name'];
        int orderPrice = doc['price'];
        // String orderTime = doc['time'] ?? 'None';

        // Update the state with the retrieved data
        setState(() {
          orderID = orderId;
          status = orderStatus;
          restaurantName = restaurant;
          price = orderPrice;
          // time = orderTime;
          show = true;
        });
      } else {
        // No matching document found
        setState(() {
          show = false;
        });
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error fetching order info: $e');
    }
  }

  Future<void> getOrder() async {
    try {
      // Get a reference to the Firestore instance

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query Firestore for orders where customerID matches
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('orders')
          .where('customerid', isEqualTo: user!.uid)
          .where('status', isNotEqualTo: 'completed')
          .get();

      // Initialize a temporary list to store FoodItem objects
      List<FoodItem> temp = [];

      // Iterate over the documents in the query snapshot
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Access the "Food items" array from the document
        List<dynamic> foodItemsData = doc['Food items'];

        for (var foodItemData in foodItemsData) {
          // Access the data fields of the food item
          String name = foodItemData.keys.first;
          // Access the inner map containing price and quantity
          Map<String, dynamic> innerMap = foodItemData[name];

          print(foodItemData);
          // Access the price and quantity from the inner map
          int quantity = innerMap['Quantity'] ?? 0;
          int price = innerMap['Price'] ?? 0;

          // Create a FoodItem object and add it to the temporary list
          temp.add(FoodItem(name: name, price: price, count: quantity));
        }
      }

      // Update the state with the new list of food items
      setState(() {
        foodItems = temp;
      });
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error fetching getOrder(): $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getOrderInfo();
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ui.val(0),
    ));
    return RefreshIndicator(
      displacement: 10,
      backgroundColor: ui.val(2),
      color: ui.val(4),
      onRefresh: () async {
        getOrderInfo();
        getOrder();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        height: show ? 400 : 0,
        decoration: BoxDecoration(
            color: ui.val(1).withOpacity(0.8),
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
                              color: ui.val(4),
                            ),
                          ),
                          Text(
                            "#$orderID",
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
                                color: Colors.red.withOpacity(0.7),
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
                            status,
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
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
                                color: Colors.blue.withOpacity(0.7),
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
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              SizedBox(width: 5),
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
                            restaurantName,
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
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
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
                            ),
                          ),
                          Text(
                            'Rs. $price',
                            style: TextStyle(
                              fontSize: 20,
                              color: ui.val(4),
                            ),
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
