import 'package:flutter/material.dart';

class OrderDetail {
  final int orderID;
  final int productID;
  final int quantity;

  OrderDetail(
      {required this.orderID, required this.productID, required this.quantity});
}
