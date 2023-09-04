import 'package:flutter/material.dart';
import 'package:food_delivery/classes/order.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusScreen extends StatelessWidget {
  final Order order;
  OrderStatusScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    String capitalizedString =
        order.status.substring(0, 1).toUpperCase() + order.status.substring(1);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30),
          color: Colors.white,
          onPressed: () {
            // Do something on back button press.
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order Status',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
            capitalizedString,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          Image.asset('images/cooking.gif'),
          SizedBox(height: 40),
          Text(
            '#${order.orderID}',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
