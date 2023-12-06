import 'package:flutter/material.dart';
import 'package:food_delivery/screens/home_screen.dart';
import 'package:food_delivery/screens/settings_screen.dart';
import 'package:food_delivery/screens/cart_screen.dart';
import 'package:food_delivery/screens/search_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:food_delivery/arguments/home_screen_arguments.dart';

import 'package:food_delivery/classes/UIColor.dart';

class MainNavigator extends StatefulWidget {
  static const id = 'main-navigator';
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    HomeScreenArguments homeScreenArguments =
        ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;
    return Scaffold(
      bottomNavigationBar: GNav(
        backgroundColor: ui.val(0),
        rippleColor: Colors.grey.withOpacity(0.3)!,
        hoverColor: Colors.grey.withOpacity(0.13)!,
        gap: 8,
        activeColor: Colors.white.withOpacity(0.8),
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey.withOpacity(0.05)!,
        color: Colors.white.withOpacity(0.5),
        onTabChange: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.shopping_cart,
            text: 'Cart',
          ),
          GButton(
            icon: Icons.account_circle,
            text: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        HomeScreen(
          user: homeScreenArguments.user,
          restaurants: homeScreenArguments.restaurants,
        ),
        // LoginScreen(),
        SearchScreen(),
        CartScreen(),
        SettingsScreen(customerID: homeScreenArguments.user.id),
      ][currentPageIndex],
    );
  }
}
