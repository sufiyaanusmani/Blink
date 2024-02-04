import 'package:flutter/material.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/components/animated_detail_header.dart';
import 'package:food_delivery/classes/product.dart';
// import 'package:food_delivery/classes/category.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/widgets.dart';
import 'RestrauntHelperfiles/model/product_category.dart';
import 'package:food_delivery/classes/UIColor.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui.val(0),
      body: Stack(
        children: [SliverBodyItems(restaurant: widget.restaurant)],
      ),
    );
  }
}
