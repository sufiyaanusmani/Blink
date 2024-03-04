import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_delivery/classes/cart_product.dart';
import 'package:food_delivery/classes/order.dart';
import 'package:food_delivery/firebase_services.dart';
import 'package:food_delivery/screens/order_status_screen.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:slide_to_act_reborn/slide_to_act_reborn.dart';
import 'package:food_delivery/components/time_selector.dart';
import 'package:food_delivery/classes/cart.dart';
import 'package:food_delivery/classes/UIColor.dart';
import 'package:food_delivery/services/email_send.dart';

import 'dart:math';

class YourCartScreen extends StatefulWidget {
  const YourCartScreen({super.key});

  @override
  _YourCartScreenState createState() => _YourCartScreenState();
}

class _YourCartScreenState extends State<YourCartScreen> {
  late CartProduct item;
  void getCartItems() {
    setState(() {
      itemList = Cart.cart;
    });
  }

  @override
  void initState() {
    getCartItems();
    setState(() {
      totalPrice = Cart.getTotalPrice();
    });
    super.initState();
  }

  late List<CartProduct> itemList = [];
  late int totalPrice = 0;

  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imageNames = [
      'yellow.jpg',
      'blue.jpg',
      'green.jpg',
      'bleen.jpg',
      'purple.jpg'
    ];

    String getRandomImageName() {
      Random random = Random();
      int index = random.nextInt(imageNames.length);
      return imageNames[index];
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ui.val(0),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),

            // list view
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  item = itemList[index];
                  return Padding(
                    padding: (index == 0)
                        ? const EdgeInsets.symmetric(vertical: 20.0)
                        : const EdgeInsets.only(bottom: 20.0),
                    child: Slidable(
                      key: Key('$item'),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                Cart.cart.removeAt(index);
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor: Colors.red.withOpacity(0.4),
                            icon: Icons.delete,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        padding: const EdgeInsets.only(left: 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: ui.val(1).withOpacity(0.9),
                        ),

                        // ListView row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Opacity(
                                opacity: 0.8,
                                child: Image.asset(
                                  "images/${getRandomImageName()}",
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: ui.val(4),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    '${item.product.price}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: ui.val(4).withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Cart.cart[index].decreaseQuantity();
                                      if (Cart.cart[index].quantity == 0) {
                                        Cart.cart.removeAt(index);
                                      }
                                      if (Cart.cart.isEmpty) {
                                        Cart.cart = [];
                                        Cart.restaurantID = "-1";
                                      }
                                      totalPrice = Cart.getTotalPrice();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ui.val(2),
                                    ),
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                        color: ui.val(4),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ui.val(2),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    ' ${item.quantity} ',
                                    style: TextStyle(
                                        color: ui.val(4), fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Cart.cart[index].increaseQuantity();
                                      totalPrice = Cart.getTotalPrice();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ui.val(2),
                                    ),
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        color: ui.val(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // preorder
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),

                Expanded(
                    flex: 4,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: ui.val(10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 15, left: 15),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ui.val(4).withOpacity(0.4),
                                ),
                                child: Image.asset(
                                  'assets/icons/preorder.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: const EdgeInsets.only(right: 15),
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    'Preorder',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              _showTimeSelectionBottomSheet();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 4, right: 4),
                              height: 30,
                              decoration: BoxDecoration(
                                color: ui.val(0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                HomePage.preOrderText,
                                style: TextStyle(
                                  color: ui.val(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 5,
                ),

                // Amount
                Expanded(
                    flex: 6,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: ui.val(3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 45, left: 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ui.val(4).withOpacity(0.2),
                            ),
                            child: Image.asset(
                              'assets/icons/layer.png',
                              width: 25,
                              height: 30,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 20, bottom: 1, right: 15),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'amount',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: ui.val(0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      'Rs $totalPrice',
                                      style: TextStyle(
                                        color: ui.val(4),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            // bottom Slider
            AbsorbPointer(
              absorbing: (Cart.cart.isNotEmpty) ? false : true,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                //https://pub.dev/packages/slide_to_act_reborn
                child: SlideAction(
                  innerColor: const Color.fromARGB(255, 0, 0, 0),
                  outerColor: ui.val(10),
                  elevation: 0,
                  sliderButtonIcon: Text(
                    'GO',
                    style: TextStyle(
                      fontFamily: 'Gruppo',
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: ui.val(4),
                    ),
                  ),
                  sliderRotate: false,
                  onSubmit: () async {
                    if (Cart.cart.isEmpty) {
                      AnimatedSnackBar.material(
                        'Cart is empty',
                        borderRadius: BorderRadius.circular(10),
                        duration: const Duration(seconds: 4),
                        type: AnimatedSnackBarType.error,
                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                      ).show(context);
                    } else {
                      var db = FirebaseServices();
                      if (await db.alreadyOrdered()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red.shade400,
                            duration: Duration(seconds: 2),
                            content: Text("Order Already in Queue!",
                                style: TextStyle(color: Colors.white)),
                            action: SnackBarAction(
                              label: 'Close',
                              textColor: Colors.white,
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                          ),
                        );
                      } else {
                        String orderID = "";
                        if (HomePage.preOrder == false) {
                          orderID = await db.placeOrder(
                              itemList,
                              Cart.restaurantID,
                              Cart.restaurantName,
                              totalPrice);
                        }
                        /*Pre-order */
                        // else {
                        //   orderID = await db.placePreOrder(
                        //       Cart.customerID, Cart.restaurantID, totalPrice);
                        //   HomePage.preOrder = false;
                        // }

                        // Iterable<ResultSetRow> rows = await db.getResults(
                        //     'SELECT order_id, name, status, price FROM Orders INNER JOIN Restaurant ON Orders.restaurant_id=Restaurant.restaurant_id WHERE customer_id=${Cart.customerID} ORDER BY placed_at DESC LIMIT 1;');
                        // int price = 0;
                        // String restaurantName = '';
                        // String status = '';
                        // if (rows.length == 1) {
                        // for (var row in rows) {
                        //   restaurantName = row.assoc()['name']!;
                        //   status = row.assoc()['status']!;
                        //   price = int.parse(row.assoc()['price']!);
                        // }
                        // Order order = Order(
                        //     orderID: orderID,
                        //     restaurantName: restaurantName,
                        //     status: status,
                        //     price: price);
                        // for (CartProduct product in Cart.cart) {
                        //   db.addOrderDetail(
                        //       orderID, product.product.id, product.quantity);
                        // }
                        setState(() {
                          Cart.cart = [];
                          itemList = [];
                          totalPrice = 0;
                          HomePage.preOrderHour = 8;
                          HomePage.preOrderMinute = 0;
                          HomePage.preOrder = false;
                          HomePage.preOrderText = "08:00 am";
                        });
                        // EmailSender email = EmailSender();
                        // email.sendEmail(orderID);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue.shade800,
                            duration: Duration(seconds: 2),
                            content: Text("Order placed ${orderID}",
                                style: TextStyle(color: Colors.white)),
                            action: SnackBarAction(
                              label: 'Close',
                              textColor: Colors.white,
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                          ),
                        );

                        // _showPopup(context, order);

                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (_, animation, __) => FadeTransition(
                        //       opacity: animation,
                        //       child: OrderStatusScreen(order: order),
                        //     ),
                        //   ),
                        // );
                        // }
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '> ',
                        style: TextStyle(
                          fontFamily: 'Gruppo',
                          fontSize: 55,
                          color: ui.val(0),
                        ),
                      ),
                      Text(
                        '> ',
                        style: TextStyle(
                          fontFamily: 'Gruppo',
                          fontSize: 55,
                          color: ui.val(0),
                        ),
                      ),
                      Text(
                        '>',
                        style: TextStyle(
                          fontFamily: 'Gruppo',
                          fontSize: 55,
                          color: ui.val(0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showPopup(BuildContext context, Order order) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String capitalizedString = order.status.substring(0, 1).toUpperCase() +
            order.status.substring(1);
        return AlertDialog(
          backgroundColor: ui.val(2),
          title: Text(
            'Order Details',
            style: TextStyle(color: ui.val(4), fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Order ID: ${order.orderID}',
                  style:
                      TextStyle(color: ui.val(4), fontWeight: FontWeight.w600),
                ),
                Text(
                  'Order status: ${capitalizedString}',
                  style:
                      TextStyle(color: ui.val(4), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the popup
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style:
                    TextStyle(color: ui.val(10), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTimeSelectionBottomSheet() {
    showModalBottomSheet(
        backgroundColor: ui.val(1),
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 30),
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  // border: Border.all(color: Color.fromARGB(62, 0, 0, 0), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: ui.val(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(12, 0, 0, 0)),
                            child: Image.asset(
                              'assets/icons/feather.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Select preorder time",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(right: 10),
                        child: const Text(
                          "Place your order in advance",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            HomePage.preOrder = true;
                            HomePage.preOrderText =
                                "${HomePage.preOrderHour < 10 ? '0${HomePage.preOrderHour}' : HomePage.preOrderHour.toString()}:${HomePage.preOrderMinute < 10 ? '0${HomePage.preOrderMinute}' : HomePage.preOrderMinute.toString()} ${HomePage.preOrderHour >= 12 || HomePage.preOrderHour <= 4 ? 'pm' : 'am'}";
                          });
                        },
                        splashColor: const Color.fromARGB(255, 0, 0, 0),
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: ui.val(0),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Center(
                            child: Text(
                              'Proceed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.topRight,
                child: const HomePage(),
              ),
            ],
          );
        });
  }
}
