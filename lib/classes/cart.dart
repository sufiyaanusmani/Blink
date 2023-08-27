import 'package:food_delivery/classes/cart_product.dart';
import 'package:food_delivery/classes/product.dart';

class Cart {
  static List<CartProduct> cart = [];

  static void addNewProduct(Product product) {
    bool exists = false;
    if (cart.length == 0) {
      cart.add(CartProduct(product: product));
      print('added new');
    } else {
      for (int i = 0; i < cart.length; i++) {
        if (cart[i].product.id == product.id) {
          cart[i].quantity++;
          print('added another');
          exists = true;
          break;
        }
      }
      if (exists == false) {
        cart.add(CartProduct(product: product));
        print('added new');
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
