import 'package:food_delivery/classes/product.dart';

// a re-implementaion of restraunt.dart
// this class is wes never used

class Menu {
  int rating;
  String restaurantName;
  String description;
  int time;
  List<Product> products;

  Menu(
      {required this.rating,
      required this.restaurantName,
      required this.description,
      required this.time,
      required this.products});
}
