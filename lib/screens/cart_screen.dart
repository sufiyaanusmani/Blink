import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/components/saved_meals.dart';
import 'package:food_delivery/components/your_cart_screen.dart';
import 'package:food_delivery/classes/UIColor.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ui.val(0),
    ));
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: ui.val(0),
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
                        color: ui.val(2),
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
                        splashBorderRadius: BorderRadius.circular(30),
                        labelColor: ui.val(4),
                        unselectedLabelColor: Color.fromARGB(255, 0, 0, 0),
                        isScrollable: false,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ui.val(1)),
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
