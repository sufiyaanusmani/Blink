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
                              'Saved meals',
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
                  InkWell(
                    onTap: () {
                      print('Button pressed');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/icons/save.png',
                        width: 25,
                        height: 25,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                  )
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
