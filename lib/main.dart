import 'package:flutter/material.dart';
import 'package:food_delivery/api/firebase_api.dart';
import 'package:food_delivery/services/navigator.dart';
import 'package:food_delivery/screens/forgot_password_screen.dart';
import 'package:food_delivery/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
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
            color: Colors.black,
          ),
        ),
      ),

      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        MainNavigator.id: (context) => const MainNavigator(),
        '/': (context) => LoginScreen(),
        ForgotPassword.id: (context) => const ForgotPassword()
        // HomeScreen.id: (context) => HomeScreen(loginID: -1),
        // RestaurantScreen.id: (context) => RestaurantScreen(),
        // SettingsScreen.id: (context) => SettingsScreen(),
      },

      // home: MainNavigator(),
      // home: OnboardingScreen(),
    );
  }
}
