import 'package:food_delivery/user.dart';
import 'package:food_delivery/classes/restaurant.dart';

class HomeScreenArguments {
  User user;
  List<Restaurant> restaurants;

  HomeScreenArguments({required this.user, required this.restaurants});
}
