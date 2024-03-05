import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrderHistory {
  final String orderID;
  final String date;
  final String status;
  final int price;
  final String restaurantName;

  /// Constructor for [OrderHistory]
  ///
  /// Parameters:
  ///   - orderID: [String]
  ///   - date: [String]
  ///   - status: [String]
  ///   - price: [int]
  ///   - restaurantName: [String]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// OrderHistory obj = OrderHistory(orderID, date, status, price, restaurantName);
  /// ```
  OrderHistory(
      {required this.orderID,
      required this.date,
      required this.status,
      required this.price,
      required this.restaurantName});

  /// Fetches order history of logged in customer
  ///
  /// Parameters:
  ///   - customerID: [String]
  ///
  /// Returns:
  ///   Future<List<OrderHistory>>
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// List<OrderHistory> orderHistory = await OrderHistory.getOrderHistory(customerID);
  /// ```
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
      if (kDebugMode) {
        print(e);
      }
    }

    return orders;
  }
}
