import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  static const String id = 'restaurant_screen';
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('Restaurant Screen'),
      ),
    );
  }
}
