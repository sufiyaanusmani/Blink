import 'package:food_delivery/classes/product.dart';

class CartProduct {
  late Product product;
  late int quantity;

  /// Constructor for [CartProduct]
  ///
  /// Parameters:
  ///   - product: [Product]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// CartProduct obj = CartProduct(product);
  /// ```
  CartProduct({required this.product}) {
    quantity = 1;
  }

  /// Increases the quantity of a particular [CartProduct]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// cartProduct.increaseQuantity();
  /// ```
  void increaseQuantity() {
    quantity++;
  }

  /// Decreases the quantity of a particular [CartProduct]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// cartProduct.decreaseQuantity();
  /// ```
  void decreaseQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }

  /// Returns total price of a price according to its quantity [price * quantity]
  ///
  /// Returns:
  ///   [int]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// cartProduct.getTotalPrice();
  /// ```
  int getTotalPrice() {
    return product.price * quantity;
  }
}
