import 'package:food_delivery/classes/product.dart';

class CartProduct {
  late Product product;
  late int quantity;

  CartProduct({required this.product}) {
    quantity = 1;
  }

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }

  int getTotalPrice() {
    return product.price * quantity;
  }
}
