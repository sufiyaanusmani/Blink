import 'package:food_delivery/classes/cart_product.dart';
import 'package:food_delivery/classes/product.dart';

class Cart {
  static List<CartProduct> cart = [];
  static String restaurantID = "-1";
  static int customerID = -1;
  static String restaurantName = "";

  /// Adds a product to the cart
  ///
  /// Parameters:
  ///   - product: [Product]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// Cart.addNewProduct(product);
  /// ```
  static void addNewProduct(Product product) {
    bool exists = false;
    if (cart.isEmpty) {
      cart.add(CartProduct(product: product));
      restaurantID = product.restaurantID;
      restaurantName = product.restaurantName;
    } else {
      for (int i = 0; i < cart.length; i++) {
        if (cart[i].product.id == product.id) {
          cart[i].quantity++;
          exists = true;
          break;
        }
      }
      if (exists == false) {
        cart.add(CartProduct(product: product));
      }
    }
  }

  /// Returns total price of products stored in cart
  ///
  /// Returns:
  ///   [int]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// Cart.getTotalPrice();
  /// ```
  static int getTotalPrice() {
    int total = 0;
    for (CartProduct product in cart) {
      total += product.getTotalPrice();
    }
    return total;
  }
}
