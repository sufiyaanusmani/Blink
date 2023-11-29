import 'package:flutter/material.dart';
import 'package:food_delivery/components/saved_meals.dart';
import 'package:food_delivery/components/your_cart_screen.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int currentTab = 0; // Initialize the current selected tab index

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(248, 174, 188, 235),
                      ),
                      child: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              'Your Cart',
                              style: TextStyle(),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Recent',
                              style: TextStyle(),
                            ),
                          ),
                        ],
                        labelColor: Color.fromARGB(255, 255, 255, 255),
                        unselectedLabelColor: Color.fromARGB(255, 0, 0, 0),
                        isScrollable: false,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    YourCartScreen(),
                    SavedMealsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
