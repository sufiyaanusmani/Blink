import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class OrderHistory {
  final String orderID;
  final String date;
  final String status;
  final int price;
  final String restaurantName;

  OrderHistory(
      {required this.orderID,
      required this.date,
      required this.status,
      required this.price,
      required this.restaurantName});

  static Future<List<OrderHistory>> getOrderHistory(String customerID) async {
    List<OrderHistory> orders = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("orders")
          .where("customerid", isEqualTo: customerID)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> order = doc.data() as Map<String, dynamic>;
        orders.add(OrderHistory(
            orderID: doc.id,
            date: order["placedat"].toString(),
            status: order["status"],
            price: order["price"],
            restaurantName: order["restaurant"]["name"]));
      }
    } catch (e) {
      print(e);
    }

    return orders;
  }
}
