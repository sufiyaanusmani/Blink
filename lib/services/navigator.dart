import 'package:flutter/material.dart';
import 'package:food_delivery/screens/home_screen.dart';
import 'package:food_delivery/screens/restaurant_screen.dart';
import 'package:food_delivery/screens/settings_screen.dart';
import 'package:food_delivery/screens/cart_screen.dart';
import 'package:food_delivery/screens/search_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:food_delivery/screens/login_screen.dart';

class MainNavigator extends StatefulWidget {
  static const id = 'main-navigator';
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int currentPageIndex = 0;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     bottomNavigationBar: NavigationBar(
  //       onDestinationSelected: (int index) {
  //         setState(() {
  //           currentPageIndex = index;
  //         });
  //       },
  //       selectedIndex: currentPageIndex,
  //       destinations: const <Widget>[
  //         NavigationDestination(
  //           icon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         NavigationDestination(
  //           icon: Icon(Icons.search),
  //           label: 'Search',
  //         ),
  //         NavigationDestination(
  //           // selectedIcon: Icon(Icons.bookmark), // jab is par click karain gai to yeh icon show hoga phir
  //           icon: Icon(Icons.shopping_cart),
  //           label: 'Cart',
  //         ),
  //         NavigationDestination(
  //           // selectedIcon: Icon(Icons.bookmark),
  //           icon: Icon(Icons.account_circle),
  //           label: 'Profile',
  //         ),
  //       ],
  //     ),
  //     body: <Widget>[
  //       HomeScreen(),
  //       SearchScreen(),
  //       CartScreen(),
  //       SettingsScreen(),
  //     ][currentPageIndex],
  //   );
  // }

  // https://pub.dev/packages/google_nav_bar/install
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: Colors.black,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey[100]!,
        color: Colors.black,
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
        HomeScreen(),
        // SearchScreen(),
        LoginScreen(),
        CartScreen(),
        SettingsScreen(),
      ][currentPageIndex],
    );
  }
}
