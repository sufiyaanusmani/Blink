import 'package:food_delivery/classes/product.dart';

// a re-implementation of restaurant.dart
// this class is wes never used

class Menu {
  int rating;
  String restaurantName;
  String description;
  int time;
  List<Product> products;

  /// Constructor for [Menu]
  ///
  /// Parameters:
  ///   - rating: [int]
  ///   - restaurantName: [String]
  ///   - description: [String]
  ///   - time: [int]
  ///   - products: [List<Product>]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// Menu obj = Menu(rating, restaurantName, description, time, products);
  /// ```
  Menu(
      {required this.rating,
      required this.restaurantName,
      required this.description,
      required this.time,
      required this.products});
}
