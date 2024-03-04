import 'package:food_delivery/classes/user1.dart';
import 'package:food_delivery/classes/restaurant.dart';

class HomeScreenArguments {
  User1 user;
  List<Restaurant> restaurants;

  HomeScreenArguments({required this.user, required this.restaurants});
}
