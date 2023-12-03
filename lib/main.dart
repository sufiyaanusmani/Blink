import 'package:flutter/material.dart';
import 'package:food_delivery/services/navigator.dart';
import 'package:food_delivery/screens/login_screen.dart';

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

      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        MainNavigator.id: (context) => MainNavigator(),
        // HomeScreen.id: (context) => HomeScreen(loginID: -1),
        // RestaurantScreen.id: (context) => RestaurantScreen(),
        // SettingsScreen.id: (context) => SettingsScreen(),
      },

      // home: MainNavigator(),
      // home: OnboardingScreen(),
    );
  }
}
