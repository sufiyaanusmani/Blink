import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_delivery/classes/cart_product.dart';
import 'package:food_delivery/classes/order.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/screens/order_status_screen.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:slide_to_act_reborn/slide_to_act_reborn.dart';
import 'package:food_delivery/components/time_selector.dart';
import 'package:food_delivery/classes/cart.dart';

class YourCartScreen extends StatefulWidget {
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
    print('${Cart.cart.length}');
    super.initState();
  }

  late List<CartProduct> itemList = [];
  late int totalPrice = 0;

  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),

            // list view
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
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
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.0),
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //       blurRadius: 1.0,
                          //       spreadRadius: 1.0,
                          //       color: Colors.grey[400]!),
                          // ],
                        ),

                        // ListView row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Opacity(
                                opacity: 0.95,
                                child: Image.asset(
                                  'images/kfc.jpg',
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
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    '${item.product.price}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
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
                                      if (Cart.cart.length == 0) {
                                        Cart.cart = [];
                                        Cart.restaurantID = -1;
                                      }
                                      totalPrice = Cart.getTotalPrice();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 50,
                                    child: const Text(
                                      '-',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    ' ${item.quantity} ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
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
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
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
                        color: const Color.fromARGB(255, 64, 140, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15, left: 15),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(136, 255, 255, 255),
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
                                  margin: EdgeInsets.only(right: 15),
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Preorder',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              _showTimeSelectionBottomSheet();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 4, right: 4),
                              height: 30,
                              child: Text(
                                HomePage.preOrderText,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
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
                        color: const Color.fromARGB(115, 158, 158, 158),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 45, left: 15),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(136, 255, 255, 255),
                            ),
                            child: Image.asset(
                              'assets/icons/layer.png',
                              width: 25,
                              height: 30,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 1, right: 15),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'amount',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      'Rs $totalPrice',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 30,
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
              absorbing: Cart.cart.length > 0 ? false : true,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                //https://pub.dev/packages/slide_to_act_reborn
                child: SlideAction(
                  innerColor: Color.fromARGB(255, 0, 0, 0),
                  outerColor: Color.fromARGB(255, 171, 90, 194),
                  elevation: 0,
                  sliderButtonIcon: Container(
                    child: Text(
                      'GO',
                      style: TextStyle(
                        fontFamily: 'Gruppo',
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  sliderRotate: false,
                  onSubmit: () async {
                    if (Cart.cart.length == 0) {
                      AnimatedSnackBar.material(
                        'Cart is empty',
                        borderRadius: BorderRadius.circular(10),
                        duration: Duration(seconds: 4),
                        type: AnimatedSnackBarType.error,
                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                      ).show(context);
                    } else {
                      var db = Mysql();
                      if (await db.alreadyOrdered(Cart.customerID)) {
                        AnimatedSnackBar.material(
                          'You can only place one order at a time',
                          borderRadius: BorderRadius.circular(10),
                          duration: Duration(seconds: 4),
                          type: AnimatedSnackBarType.error,
                          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                        ).show(context);
                      } else {
                        int orderID = 0;
                        if (HomePage.preOrder == false) {
                          orderID = await db.placeOrder(
                              Cart.customerID, Cart.restaurantID, totalPrice);
                        } else {
                          orderID = await db.placePreOrder(
                              Cart.customerID, Cart.restaurantID, totalPrice);
                          HomePage.preOrder = false;
                        }
                        Iterable<ResultSetRow> rows = await db.getResults(
                            'SELECT order_id, name, status, price FROM Orders INNER JOIN Restaurant ON Orders.restaurant_id=Restaurant.restaurant_id WHERE customer_id=${Cart.customerID} ORDER BY placed_at DESC LIMIT 1;');
                        print('line 371');
                        print(orderID);
                        int price = 0;
                        String restaurantName = '';
                        String status = '';
                        print(rows.length);
                        if (rows.length == 1) {
                          for (var row in rows) {
                            print(orderID);
                            restaurantName = row.assoc()['name']!;
                            status = row.assoc()['status']!;
                            price = int.parse(row.assoc()['price']!);
                          }
                          Order order = Order(
                              orderID: orderID,
                              restaurantName: restaurantName,
                              status: status,
                              price: price);
                          print(orderID);
                          for (CartProduct product in Cart.cart) {
                            db.addOrderDetail(
                                orderID, product.product.id, product.quantity);
                          }
                          setState(() {
                            Cart.cart = [];
                            itemList = [];
                            totalPrice = 0;
                            HomePage.preOrderHour = 8;
                            HomePage.preOrderMinute = 0;
                            HomePage.preOrder = false;
                            HomePage.preOrderText = "08:00 am";
                          });

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) => FadeTransition(
                                opacity: animation,
                                child: OrderStatusScreen(order: order),
                              ),
                            ),
                          );
                        }
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
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '> ',
                        style: TextStyle(
                          fontFamily: 'Gruppo',
                          fontSize: 55,
                          color: Color.fromARGB(171, 255, 255, 255),
                        ),
                      ),
                      Text(
                        '>',
                        style: TextStyle(
                          fontFamily: 'Gruppo',
                          fontSize: 55,
                          color: Color.fromARGB(111, 255, 255, 255),
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

  void _showTimeSelectionBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 30),
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  // border: Border.all(color: Color.fromARGB(62, 0, 0, 0), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(94, 84, 110, 255),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
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
                      Container(
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
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
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
                                "${HomePage.preOrderHour < 10 ? '0' + HomePage.preOrderHour.toString() : HomePage.preOrderHour.toString()}:${HomePage.preOrderMinute < 10 ? '0' + HomePage.preOrderMinute.toString() : HomePage.preOrderMinute.toString()} ${HomePage.preOrderHour >= 12 || HomePage.preOrderHour <= 4 ? 'pm' : 'am'}";
                          });
                        },
                        splashColor: Color.fromARGB(255, 0, 0, 0),
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
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
                child: HomePage(),
              ),
            ],
          );
        });
  }
}
