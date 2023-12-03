import 'package:food_delivery/classes/cart_product.dart';
import 'package:food_delivery/classes/product.dart';

class Cart {
  static List<CartProduct> cart = [];
  static int restaurantID = -1;
  static int customerID = -1;

  static void addNewProduct(Product product) {
    bool exists = false;
    if (cart.isEmpty) {
      cart.add(CartProduct(product: product));
      restaurantID = product.restaurantID;
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

  static int getTotalPrice() {
    int total = 0;
    for (CartProduct product in cart) {
      total += product.getTotalPrice();
    }
    return total;
  }
}
