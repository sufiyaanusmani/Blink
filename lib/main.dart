import 'package:flutter/material.dart';
import 'package:food_delivery/services/navigator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery/splashscreen/screen.dart';


void main() {
  runApp(FoodDelivery());
}

class FoodDelivery extends StatelessWidget {
  const FoodDelivery({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),

      // initialRoute: SettingsScreen.id,
      // routes: {
      //   HomeScreen.id: (context) => HomeScreen(),
      //   RestaurantScreen.id: (context) => RestaurantScreen(),
      //   SettingsScreen.id: (context) => SettingsScreen(),
      // },

      home: MainNavigator(),
      // home: OnboardingScreen(),
    );
  }
}
