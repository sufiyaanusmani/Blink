import 'package:flutter/material.dart';
import 'package:food_delivery/screens/home_screen.dart';
import 'package:food_delivery/screens/restaurant_screen.dart';
import 'package:food_delivery/screens/settings_screen.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  List<Widget> _screens = [
    HomeScreen(),
    RestaurantScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return
     NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
      height: 20,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          // selectedIcon: Icon(Icons.bookmark), // jab is par click karain gai to yeh icon show hoga phir
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        NavigationDestination(
          // selectedIcon: Icon(Icons.bookmark),
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      

    );
  }
}
