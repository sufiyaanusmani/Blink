import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  // List<Widget> _screens = [
  //   // HomeScreen(),
  //   RestaurantScreen(),
  //   SettingsScreen(),
  // ];

  // @override
  // Widget build(BuildContext context) {
  //   return
  //    NavigationBar(
  //     onDestinationSelected: (int index) {
  //       setState(() {
  //         currentPageIndex = index;
  //       });
  //     },
  //     selectedIndex: currentPageIndex,
  //     height: 20,
  //     destinations: const <Widget>[
  //       NavigationDestination(
  //         icon: Icon(Icons.home),
  //         label: 'Home',
  //       ),
  //       NavigationDestination(
  //         icon: Icon(Icons.search),
  //         label: 'Search',
  //       ),
  //       NavigationDestination(
  //         // selectedIcon: Icon(Icons.bookmark), // jab is par click karain gai to yeh icon show hoga phir
  //         icon: Icon(Icons.shopping_cart),
  //         label: 'Cart',
  //       ),
  //       NavigationDestination(
  //         // selectedIcon: Icon(Icons.bookmark),
  //         icon: Icon(Icons.account_circle),
  //         label: 'Profile',
  //       ),
  //     ],

  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GNav(
      onTabChange: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
      rippleColor: Colors.grey[300]!,
      hoverColor: Colors.grey[100]!,
      gap: 8,
      activeColor: Colors.black,
      iconSize: 24,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      duration: Duration(milliseconds: 400),
      tabBackgroundColor: Colors.grey[100]!,
      color: Colors.black,
      tabs: [
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
    );
  }
}
