import 'package:food_delivery/classes/product.dart';

class Category {
  // int id;
  String name;
  List<Product> products = [];

  /// Constructor for [Category]
  ///
  /// Parameters:
  ///   - name: [String]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// Category obj = Category(name);
  /// ```
  Category({required this.name});
}
